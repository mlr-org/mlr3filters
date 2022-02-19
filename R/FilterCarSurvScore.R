#' @title Correlation-Adjusted Survival Score Filter
#'
#' @name mlr_filters_carsurvscore
#'
#' @description Calculates CARS scores for right-censored survival tasks.
#' Calls the implementation in [carSurv::carSurvScore()] in package
#' \CRANpkg{carSurv}.
#'
#' @references
#' `r format_bib("bommert_2021")`
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("mlr3proba")) {
#'   task = mlr3::tsk("gbcs")
#'   filter = flt("carsurvscore")
#'   filter$calculate(task)
#'   head(as.data.table(filter), 3)
#' }
FilterCarSurvScore = R6Class("FilterCarSurvScore",
  inherit = Filter,

  public = list(
    #' @description Create a FilterCarSurvScore object.
    initialize = function() {
      ps = ps(
        maxIPCweight = p_int(lower = 0, default = 10),
        denom = p_fct(c("1/n", "sum_w"), default = "1/n")
      )
      super$initialize(
        id = "surv.carsurvscore",
        packages = c("carSurv", "mlr3proba"),
        param_set = ps,
        feature_types = c("integer", "numeric"),
        task_type = "surv",
        man = "mlr3filters::mlr_filters_carsurvscore"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values

      surv = task$truth()
      X = as.matrix(task$data(cols = task$feature_names))
      scores = invoke(carSurv::carSurvScore,
        obsTime = surv[, 1L],
        obsEvent = surv[, 2L],
        X = X,
        .args = pv
      )

      set_names(abs(scores), colnames(X))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("carsurvscore", FilterCarSurvScore)
