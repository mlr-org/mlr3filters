#' @title Correlation-Adjusted Marignal Correlation Score Filter
#'
#' @name mlr_filters_carscore
#'
#' @description Calculates the Correlation-Adjusted (marginal) coRrelation scores
#' (short CAR scores) implemented in [care::carscore()] in package
#' \CRANpkg{care}. The CAR scores for a set of features are defined as the
#' correlations between the target and the decorrelated features. The filter
#' returns the absolute value of the calculated scores.
#'
#' Argument `verbose` defaults to `FALSE`.
#'
#' @family Filter
#' @include Filter.R
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("care")) {
#'   task = mlr3::tsk("mtcars")
#'   filter = flt("carscore")
#'   filter$calculate(task)
#'   head(as.data.table(filter), 3)
#'
#'   ## changing the filter settings
#'   filter = flt("carscore")
#'   filter$param_set$values = list("diagonal" = TRUE)
#'   filter$calculate(task)
#'   head(as.data.table(filter), 3)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "care", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("mtcars")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("carscore"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("regr.rpart"))
#'
#'   graph$train(task)
#' }
FilterCarScore = R6Class("FilterCarScore",
  inherit = Filter,

  public = list(
    #' @description Create a FilterCarScore object.
    initialize = function() {
      param_set = ps(
        lambda   = p_dbl(lower = 0, upper = 1, default = NO_DEF),
        diagonal = p_lgl(default = FALSE),
        verbose  = p_lgl(default = TRUE)
      )
      param_set$values = list(verbose = FALSE)

      super$initialize(
        id = "carscore",
        task_types = "regr",
        param_set = param_set,
        feature_types = c("logical", "integer", "numeric"),
        packages = "care",
        label = "Correlation-Adjusted coRrelation Score",
        man = "mlr3filters::mlr_filters_carscore"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      target = task$truth()
      features = as_numeric_matrix(task$data(cols = task$feature_names))

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
