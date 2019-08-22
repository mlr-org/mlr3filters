#' @title Filter for Embedded Feature Selection via Variable Importance
#'
#' @usage NULL
#' @aliases mlr_filters_variable_importance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterImportance$new(learner = mlr3::lrn("classif.rpart"))
#' mlr_filters$get("importance")
#' flt("importance")
#' ```
#'
#' * `learner` :: [mlr3::Learner]\cr
#'   Learner to extract the importance values from.
#'
#' @description Variable Importance filter using embedded feature selection of
#' machine learning algorithms. Takes a [mlr3::Learner] which is capable of
#' extracting the variable importance (property "importance"), fits the model
#' and extracts the importance values to use as filter scores.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' learner = mlr3::mlr_learners$get("classif.rpart")
#' filter = FilterImportance$new(learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterImportance = R6Class("FilterImportance", inherit = Filter,
  public = list(
    learner = NULL,
    initialize = function(learner = mlr3::lrn("classif.rpart")) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE), properties = "importance")

      super$initialize(
        id = "importance",
        packages = learner$packages,
        param_set = learner$param_set,
        feature_types = learner$feature_types,
        task_type = learner$task_type
      )
    },

    calculate_internal = function(task, nfeat) {
      learner = self$learner$clone(deep = TRUE)
      learner = learner$train(task = task)
      learner$importance()
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("importance", FilterImportance)
