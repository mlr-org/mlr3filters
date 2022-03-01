#' @title Conditional Mutual Information Based Feature Selection Filter
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
    initialize = function() {
      param_set = ps(
        lambda   = p_dbl(lower = 0, upper = 1, default = NO_DEF),
        diagonal = p_lgl(default = FALSE),
        verbose  = p_lgl(default = TRUE)
      )
      param_set$values = list(verbose = FALSE)

      super$initialize(
        id = "carscore",
        task_type = "regr",
        param_set = param_set,
        feature_types = "numeric",
        packages = "care",
        label = "Correlation-Adjusted marginal coRrelation Score",
        man = "mlr3filters::mlr_filters_carscore"
      )
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
