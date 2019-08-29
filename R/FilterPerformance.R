#' @title Predictive Performance Filter
#'
#' @usage NULL
#' @aliases mlr_filters_performance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterPerformance$new(learner = mlr3::lrn("classif.rpart"),
#'   resampling = mlr3::rsmp("holdout"), measure = mlr3::msr("classif.ce"))
#' mlr_filters$get("performance")
#' flt("performance")
#' ```
#' * `learner` :: [mlr3::Learner].
#' * `resampling` :: [mlr3::Resampling].
#' * `measure` :: [mlr3::Measure].
#'
#' @description Filter which uses the predictive performance of a
#' [mlr3::Learner] as filter score. Performs a [mlr3::resample()] for each
#' feature separately. The filter score is the aggregated performance of the
#' [mlr3::Measure], or the negated aggregated performance if the measure has
#' to be minimized.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = tsk("iris")
#' learner = lrn("classif.rpart")
#' filter = flt("performance", learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterPerformance = R6Class("FilterPerformance", inherit = Filter,
  public = list(
    learner = NULL,
    resampling = NULL,
    measure = NULL,

    initialize = function(learner = mlr3::lrn("classif.rpart"), resampling = mlr3::rsmp("holdout"), measure = mlr3::msr("classif.ce")) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE), properties = "importance")
      self$resampling = assert_resampling(as_resampling(resampling))
      self$measure = assert_measure(as_measure(measure, task_type = learner$task_type, clone = TRUE), learner = learner)

      super$initialize(
        id = "performance",
        packages = learner$packages,
        param_set = learner$param_set,
        feature_types = learner$feature_types,
        task_type = learner$task_type
      )
    },

    calculate_internal = function(task, nfeat) {
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
