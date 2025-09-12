#' @title Permutation Score Filter
#'
#' @name mlr_filters_permutation
#'
#' @description
#' The permutation filter randomly permutes the values of a single feature in a
#' [mlr3::Task] to break the association with the response. The permuted
#' feature, together with the unmodified features, is used to perform a
#' [mlr3::resample()]. The permutation filter score is the difference between
#' the aggregated performance of the [mlr3::Measure] and the performance
#' estimated on the unmodified [mlr3::Task].
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
#' @include FilterLearner.R
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("rpart")) {
#'   learner = mlr3::lrn("classif.rpart")
#'   resampling = mlr3::rsmp("holdout")
#'   measure = mlr3::msr("classif.acc")
#'   filter = flt("permutation", learner = learner, measure = measure, resampling = resampling,
#'     nmc = 2)
#'   task = mlr3::tsk("iris")
#'   filter$calculate(task)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("iris")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("permutation", nmc = 2), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterPermutation = R6Class("FilterPermutation",
  inherit = FilterLearner,
  public = list(

    #' @field learner ([mlr3::Learner])\cr
    learner = NULL,
    #' @field resampling ([mlr3::Resampling])\cr
    resampling = NULL,
    #' @field measure ([mlr3::Measure])\cr
    measure = NULL,

    #' @description Create a FilterPermutation object.
    #' @param learner ([mlr3::Learner])\cr
    #'   [mlr3::Learner] to use for model fitting.
    #' @param resampling ([mlr3::Resampling])\cr
    #'   [mlr3::Resampling] to be used within resampling.
    #' @param measure ([mlr3::Measure])\cr
    #'   [mlr3::Measure] to be used for evaluating the performance.
    initialize = function(learner = mlr3::lrn("classif.featureless"), resampling = mlr3::rsmp("holdout"),
      measure = NULL) {

      param_set = ps(
        standardize = p_lgl(default = FALSE),
        nmc         = p_int(lower = 1L, default = 50L)
      )

      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE))
      self$resampling = assert_resampling(as_resampling(resampling), instantiated = FALSE)
      self$measure = assert_measure(as_measure(measure,
        task_type = learner$task_type, clone = TRUE), learner = learner)
      packages = unique(c(self$learner$packages, self$measure$packages))

      super$initialize(
        id = "permutation",
        task_types = learner$task_type,
        feature_types = learner$feature_types,
        packages = packages,
        param_set = param_set,
        label = "Permutation Score",
        man = "mlr3filters::mlr_filters_permutation"
      )
    }
  ),

  active = list(
    #' @field hash (`character(1)`)\cr
    #' Hash (unique identifier) for this object.
    hash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$param_set$values, self$learner$hash,
        self$resampling$hash, self$measure$hash)
    },

    #' @field phash (`character(1)`)\cr
    #' Hash (unique identifier) for this partial object, excluding some components
    #' which are varied systematically during tuning (parameter values) or feature
    #' selection (feature names).
    phash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$learner$hash, self$resampling$hash,
        self$measure$hash)
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      task = task$clone()
      fn = task$feature_names
      nmc = self$param_set$values$nmc %??% 50L

      backend = task$backend
      rr = resample(task, self$learner, self$resampling)
      baseline = rr$aggregate(self$measure)

      perf = matrix(NA_real_, nrow = nmc, ncol = length(fn),
        dimnames = list(NULL, fn))

      for (j in seq_col(perf)) {
        data = task$data(cols = fn[j])

        for (i in seq_row(perf)) {
          data[[1L]] = shuffle(data[[1L]])
          task$cbind(data)
          rr = resample(task, self$learner, self$resampling)
          perf[i, j] = rr$aggregate(self$measure)

          # reset to previous backend
          # this is a bit of an ugly hack, but since we are only overwriting
          # a column with its own values during `task$cbind()`, this should pose
          # no problem.
          task$backend = backend
        }
      }

      delta = baseline - colMeans(perf)

      if (self$measure$minimize) {
        delta = -delta
      }

      if (isTRUE(self$param_set$values$standardize)) {
        delta = delta / max(delta)
      }

      delta
    },

    .get_properties = function() {
      intersect("missings", self$learner$properties)
    }
  )

)

#' @include mlr_filters.R
mlr_filters$add("permutation", FilterPermutation)
