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
FilterImportance = R6Class("FilterImportance", inherit = Filter,

  public = list(

    #' @field learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    learner = NULL,

    #' @description Create a FilterImportance object.
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
    #'   Learner to extract the importance values from.
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    initialize = function(id = "importance",
      task_type = learner$task_type,
      feature_types = learner$feature_types,
      learner = mlr3::lrn("classif.rpart"),
      packages = learner$packages,
      param_set = learner$param_set) {
      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE))

      super$initialize(
        id = id,
        task_type = task_type,
        feature_types = feature_types,
        packages = packages,
        param_set = param_set,
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
