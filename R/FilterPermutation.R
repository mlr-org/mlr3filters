#' @title Permutation Filter
#'
#' @name mlr_filters_permutation
#'
#' @description
#' Estimate how important individual features are by contrasting prediction
#' performances. Compute the change in performance from permuting the values of
#' a feature and compare that to the predictions made on the unmodified data.
#'
#' @section Parameters:
#' \describe{
#' \item{`standardize`}{`logical(1)`\cr
#' Standardize feature importance by maximum score.}
#' \item{`nmc`}{`integer(1)`}\cr
#' Number of Monte-Carlo iterations to use in computing the feature importance.
#' }
#'
#' @family Filter
#' @template seealso_filter
#' @export
FilterPermutation = R6Class("FilterPermutation",
  inherit = Filter,
  public = list(

    #' @field learner ([mlr3::Learner])\cr
    learner = NULL,
    #' @field resampling ([mlr3::Resampling])\cr
    resampling = NULL,
    #' @field measure ([mlr3::Measure])\cr
    measure = NULL,

    #' @description Create a FilterDISR object.
    #' @param id (`character(1)`)\cr
    #'   Identifier for the filter.
    #' @param task_type (`character()`)\cr
    #'   Types of the task the filter can operator on. E.g., `"classif"` or
    #'   `"regr"`.
    #' @param param_set ([paradox::ParamSet])\cr
    #'   Set of hyperparameters.
    #' @param feature_types (`character()`)\cr
    #'   Feature types the filter operates on.
    #'   Must be a subset of
    #'   [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
    #' @param learner ([mlr3::Learner])\cr
    #'   [mlr3::Learner] to use for model fitting.
    #' @param resampling ([mlr3::Resampling])\cr
    #'   [mlr3::Resampling] to be used within resampling.
    #' @param measure ([mlr3::Measure])\cr
    #'   [mlr3::Measure] to be used for evaluating the performance.
    initialize = function(id = "permutation",
      task_type = learner$task_type,
      param_set = ParamSet$new(list(
        ParamLgl$new("standardize", default = FALSE),
        ParamInt$new("nmc", default = 50L))),
      feature_types = learner$feature_types,
      learner = mlr3::lrn("classif.rpart"),
      resampling = mlr3::rsmp("holdout"),
      measure = mlr3::msr("classif.ce")) {

      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE))
      self$resampling = assert_resampling(as_resampling(resampling))
      self$measure = assert_measure(as_measure(measure,
        task_type = learner$task_type, clone = TRUE), learner = learner)
      packages = unique(c(self$learner$packages, self$measure$packages))

      super$initialize(
        id = id,
        task_type = task_type,
        feature_types = feature_types,
        packages = packages,
        param_set = param_set,
        man = "mlr3filters::mlr_filters_performance"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      task = task$clone()
      pars = self$param_set$values
      fn = task$feature_names
      pars$standardize = pars$standardize %??% FALSE
      pars$nmc = pars$nmc %??% 50L

      rr = resample(task, self$learner, self$resampling)
      baseline = rr$aggregate(self$measure)

      perf = map_dtr(seq(pars$nmc), function(i) {
        set_names(map_dtc(fn, function(x) {

          task = task$clone()
          data = task$data()
          column = data[, x, with = FALSE][[1]]
          data[, (x) := column[sample(nrow(data))]]

          # Empty task and fill with shuffled column
          task$filter(rows = 0)
          task$rbind(data)
          rr = resample(task, self$learner, self$resampling)
          rr$aggregate(self$measure)
        }), fn)
      })
      delta = baseline - as.matrix(perf[, lapply(.SD, mean)])[1, ]

      if (self$measure$minimize) {
        delta = -delta
      }

      if (pars$standardize) {
        delta = delta / max(delta)
      }
      set_names(delta, fn)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("permutation", FilterPermutation)
