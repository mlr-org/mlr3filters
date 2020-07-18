#' @title Filter for Embedded Feature Selection via Variable Importance
#'
#' @name mlr_filters_importance
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
#' task = mlr3::tsk("iris")
#' learner = mlr3::lrn("classif.rpart")
#' filter = flt("importance", learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterImportance = R6Class("FilterImportance",
  inherit = Filter,

  public = list(

    #' @field learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    learner = NULL,

    #' @description Create a FilterImportance object.
    #' @param learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    initialize = function(learner = mlr3::lrn("classif.rpart")) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE),
        properties = "importance")

      super$initialize(
        id = "importance",
        task_type = learner$task_type,
        feature_types = learner$feature_types,
        packages = learner$packages,
        param_set = learner$param_set,
        man = "mlr3filters::mlr_filters_importance"
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
mlr_filters$add("importance", FilterImportance)
