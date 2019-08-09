#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @aliases mlr_filters_carscore
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Calculates the Correlation-Adjusted (marginal) coRelation scores (short CAR scores)
#' implemented in [care::carscore()] in package \CRANpkg{care}.
#' The CAR scores for a set of features are defined as the correlations between the target
#' and the decorrelated features. The filter returns the absolute value of the calculated scores.
#'
#' Argument `verbose` defaults to `FALSE`.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("mtcars")
#' filter = FilterCarScore$new()
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterCarScore = R6Class("FilterCarScore", inherit = Filter,
  public = list(
    initialize = function(id = "carscore",  param_vals = list(verbose = FALSE) {
      super$initialize(
        id = id,
        packages = "care",
        feature_types = c("numeric"),
        task_type = "regr",
        param_set = ParamSet$new(list(
          ParamDbl$new("lambda", lower = 0, upper = 1, default = NO_DEF),
          ParamLgl$new("diagonal", default = FALSE),
          ParamLgl$new("verbose", default = TRUE))),
        param_vals = param_vals
      )
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
