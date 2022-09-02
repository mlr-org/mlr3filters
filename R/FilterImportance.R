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
#' if (requireNamespace("rpart")) {
#'   task = mlr3::tsk("iris")
#'   learner = mlr3::lrn("classif.rpart")
#'   filter = flt("importance", learner = learner)
#'   filter$calculate(task)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart", "mlr3learners"), quietly = TRUE)) {
#'   library("mlr3learners")
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   learner = mlr3::lrn("classif.rpart")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("importance", learner = learner), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.log_reg"))
#'
#'   graph$train(task)
#' }
FilterImportance = R6Class("FilterImportance",
  inherit = Filter,

  public = list(

    #' @field learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    learner = NULL,

    #' @description Create a FilterImportance object.
    #' @param learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    initialize = function(learner = mlr3::lrn("classif.featureless")) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE),
        properties = "importance")

      super$initialize(
        id = "importance",
        task_type = learner$task_type,
        feature_types = learner$feature_types,
        packages = learner$packages,
        param_set = learner$param_set,
        label = "Importance Score",
        man = "mlr3filters::mlr_filters_importance"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      learner = self$learner$clone(deep = TRUE)
      learner = learner$train(task = task)
      learner$base_learner()$importance()
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("importance", FilterImportance)
