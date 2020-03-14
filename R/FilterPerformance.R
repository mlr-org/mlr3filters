#' @title Predictive Performance Filter
#'
#' @name mlr_filters_performance
#'
#' @description Filter which uses the predictive performance of a
#'   [mlr3::Learner] as filter score. Performs a [mlr3::resample()] for each
#'   feature separately. The filter score is the aggregated performance of the
#'   [mlr3::Measure], or the negated aggregated performance if the measure has
#'   to be minimized.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' learner = mlr3::lrn("classif.rpart")
#' filter = flt("performance", learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterPerformance = R6Class("FilterPerformance", inherit = Filter,

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
    initialize = function(id = "performance",
      task_type = learner$task_type,
      param_set = learner$param_set,
      feature_types = learner$feature_types,
      learner = mlr3::lrn("classif.rpart"),
      resampling = mlr3::rsmp("holdout"),
      measure = mlr3::msr("classif.ce")) {

      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE),
        properties = "importance")
      self$resampling = assert_resampling(as_resampling(resampling))
      self$measure = assert_measure(as_measure(measure,
        task_type = learner$task_type, clone = TRUE), learner = learner)
      packages = unique(c(self$learner$packages, self$measure$packages))

      super$initialize(
        id = id,
        task_type = task_type,
        feature_types = feature_types,
        packages = packages,
        man = "mlr3filters::mlr_filters_performance"
      )
    }
  ),

  private = list(

    .calculate = function(task, nfeat) {
      task = task$clone()
      fn = task$feature_names

      perf = map_dbl(fn, function(x) {
        task$col_roles$feature = x
        rr = resample(task, self$learner, self$resampling)
        rr$aggregate()
      })

      if (self$measure$minimize) {
        perf = -perf
      }

      set_names(perf, fn)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("performance", FilterPerformance)
