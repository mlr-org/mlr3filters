#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @name mlr_filters_carscore
#'
#' @description Calculates the Correlation-Adjusted (marginal) coRelation scores
#' (short CAR scores) implemented in [care::carscore()] in package
#' \CRANpkg{care}. The CAR scores for a set of features are defined as the
#' correlations between the target and the decorrelated features. The filter
#' returns the absolute value of the calculated scores.
#'
#' Argument `verbose` defaults to `FALSE`.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("carscore")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
#'
#' ## changing filter settings
#' filter = flt("carscore")
#' filter$param_set$values = list("diagonal" = TRUE)
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
FilterCarScore = R6Class("FilterCarScore",
  inherit = Filter,

  public = list(

    #' @description Create a FilterCarScore object.
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
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    initialize = function(id = "carscore",
      task_type = "regr",
      param_set = ParamSet$new(list(
        ParamDbl$new("lambda", lower = 0, upper = 1, default = NO_DEF),
        ParamLgl$new("diagonal", default = FALSE),
        ParamLgl$new("verbose", default = TRUE))),
      packages = "care",
      feature_types = "numeric") {
      super$initialize(
        id = id,
        task_type = task_type,
        param_set = param_set,
        feature_types = feature_types,
        packages = packages,
        man = "mlr3filters::mlr_filters_carscore"

      )
      self$param_set$values = list(verbose = FALSE)
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      target = task$truth()
      features = task$data(cols = task$feature_names)

      pv = self$param_set$values
      scores = invoke(care::carscore,
        Xtrain = features, Ytrain = target,
        .args = pv)
      set_names(abs(scores), names(scores))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("carscore", FilterCarScore)
