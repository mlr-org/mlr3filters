#' @title Predictive Performance Filter
#'
#' @aliases mlr_filters_variable_importance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Filter which uses the predictive performance of a [mlr3::Learner] as filter score.
#' Performs a [mlr3::resample()] for each feature separately.
#' The filter score is the aggregated performance of the [mlr3::Measure], or the negated aggregated performance if the measure which are to be minimized.
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

    initialize = function(id = "performance", learner = "classif.rpart", resampling = "holdout", measure = NULL) {
      self$learner = learner = assert_learner(learner, properties = "importance")
      self$resampling = assert_resampling(resampling)
      self$measure = assert_measure(measure, learner = learner)

      super$initialize(
        id = id,
        packages = learner$packages,
        feature_types = learner$feature_types,
        task_type = learner$task_type
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
