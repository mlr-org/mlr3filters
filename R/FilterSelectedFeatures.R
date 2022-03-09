#' @title Filter for Embedded Feature Selection
#'
#' @name mlr_filters_selected_features
#'
#' @description
#' Filter using embedded feature selection of machine learning algorithms.
#' Takes a [mlr3::Learner] which is capable of extracting the selected features
#' (property "selected_features"), fits the model and extracts the selected
#' features.
#'
#' Note that contrary to [mlr_filters_importance], there is no ordering in
#' the selected features. Selected features get a score of 1, deselected
#' features get a score of 0. The order of selected features is random and
#' different from the order in the learner. In combination with
#' \CRANpkg{mlr3pipelines}, only the filter criterion `cutoff` makes sense.
#'
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' learner = mlr3::lrn("classif.rpart")
#' filter = flt("selected_features", learner = learner)
#' filter$calculate(task)
#' as.data.table(filter)
FilterSelectedFeatures = R6Class("FilterSelectedFeatures",
  inherit = Filter,

  public = list(

    #' @field learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    learner = NULL,

    #' @description Create a FilterImportance object.
    #'   Learner to extract the selected features from.
    initialize = function(learner = mlr3::lrn("classif.featureless")) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE),
        properties = "selected_features")

      super$initialize(
        id = "selected_features",
        task_type = learner$task_type,
        feature_types = learner$feature_types,
        packages = learner$packages,
        param_set = learner$param_set,
        label = "Embedded Feature Selection",
        man = "mlr3filters::mlr_filters_selected_features"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      learner = self$learner$clone(deep = TRUE)
      learner = learner$train(task = task)
      score = named_vector(task$feature_names, init = 0)
      replace(score, names(score) %in% learner$selected_features(), 1)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("selected_features", FilterSelectedFeatures)
