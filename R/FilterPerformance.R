#' @title Predictive Performance Filter
#'
#' @aliases mlr_filters_performance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description Filter which uses the predictive performance of a
#' [mlr3::Learner] as filter score. Performs a [mlr3::resample()] for each
#' feature separately. The filter score is the aggregated performance of the
#' [mlr3::Measure], or the negated aggregated performance if the measure which
#' are to be minimized.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' learner = mlr3::mlr_learners$get("classif.rpart")
#' filter = FilterPerformance$new(learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterPerformance = R6Class("FilterPerformance", inherit = Filter,
  public = list(
    learner = NULL,
    resampling = NULL,
    measure = NULL,

    initialize = function(id = "performance", learner = "classif.rpart", resampling = "holdout", measure = "classif.ce") {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE), properties = "importance")
      self$resampling = assert_resampling(as_resampling(resampling))
      self$measure = assert_measure(as_measure(measure, task_type = learner$task_type, clone = TRUE), learner = learner)

      super$initialize(
        id = id,
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
