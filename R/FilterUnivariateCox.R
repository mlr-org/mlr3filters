#' @title Univariate Cox Survival Filter
#'
#' @name mlr_filters_univariate_cox
#'
#' @description Calculates scores for assessing the relationship between
#' individual features and the time-to-event outcome (right-censored survival
#' data) using a univariate Cox proportional hazards model.
#' The goal is to determine which features have a statistically significant
#' association with the event of interest, typically in the context of clinical
#' or biomedical research.
#'
#' This filter fits a [Cox Proportional Hazards][survival::coxph()] model using
#' each feature independently and extracts the \eqn{p}-value that quantifies the
#' significance of the feature's impact on survival. The filter value is
#' `-log10(p)` where `p` is the \eqn{p}-value. This transformation is necessary
#' to ensure numerical stability for very small \eqn{p}-values. Also higher
#' values denote more important features. The filter works only for numeric
#' features so please ensure that factor variables are properly encoded, e.g.
#' using [PipeOpEncode][mlr3pipelines::PipeOpEncode].
#'
#' @family Filter
#' @include Filter.R
#' @template seealso_filter
#' @export
#' @examples
#'
#' filter = flt("univariate_cox")
#' filter
#'
FilterUnivariateCox = R6Class("FilterUnivariateCox",
  inherit = Filter,
  public = list(
    #' @description Create a FilterUnivariateCox object.
    initialize = function() {
      super$initialize(
        id = "surv.univariate_cox",
        packages = "survival",
        param_set = ps(),
        feature_types = c("integer", "numeric", "logical"),
        task_types = "surv",
        label = "Univariate Cox Survival Score",
        man = "mlr3filters::mlr_filters_univariate_cox"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      features = task$feature_names
      targets  = task$data(cols = task$target_names)

      scores = map_dbl(features, function(feature) {
        model = invoke(
          survival::coxph,
          formula = task$formula(rhs = feature),
          data = cbind(task$data(cols = feature), targets)
        )
        pval = summary(model)$coefficients[, "Pr(>|z|)"]
        -log10(pval) # smaller p-values => larger scores
      })

      set_names(scores, features)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("univariate_cox", FilterUnivariateCox)
