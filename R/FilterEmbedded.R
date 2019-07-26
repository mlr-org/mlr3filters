#' @title Filter for Embedded Feature Selection
#'
#' @aliases mlr_filters_variable_importance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Variable Importance filter using embedded feature selection of machine learning algorithms.
#' Takes a [mlr3::Learner] which is capable of extracting the variable importance (property "importance"),
#' fits the model and uses the importance values as filter scores.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' learner = mlr3::mlr_learners$get("classif.rpart")
#' filter = FilterEmbedded$new(learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterEmbedded = R6Class("FilterEmbedded", inherit = Filter,
  public = list(
    learner = NULL,
    initialize = function(id = "embedded", learner = "classif.rpart") {
      self$learner = learner = assert_learner(learner, properties = "importance")

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
      learner = self$learner$clone(deep = TRUE)
      learner = learner$train(task = task)
      learner$importance()
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("embedded", FilterEmbedded)
