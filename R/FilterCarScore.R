#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @usage NULL
#' @aliases mlr_filters_carscore
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterCarScore$new()
#' mlr_filters$get("carscore")
#' flt("carscore")
#' ```
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
FilterCarScore = R6Class("FilterCarScore", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "carscore",
        packages = "care",
        feature_types = c("numeric"),
        task_type = "regr",
        param_set = ParamSet$new(list(
          ParamDbl$new("lambda", lower = 0, upper = 1, default = NO_DEF),
          ParamLgl$new("diagonal", default = FALSE),
          ParamLgl$new("verbose", default = TRUE)))
      )
      self$param_set$values = list(verbose = FALSE)
    },

    calculate_internal = function(task, nfeat) {
      target = task$truth()
      features = task$data(cols = task$feature_names)

      pv = self$param_set$values
      scores = invoke(care::carscore, Xtrain = features, Ytrain = target, .args = pv)
      set_names(abs(scores), names(scores))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("carscore", FilterCarScore)
