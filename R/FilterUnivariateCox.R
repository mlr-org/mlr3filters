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
#' if (mlr3misc::require_namespaces(c("mlr3", "mlr3proba", "mlr3pipelines"), quietly = TRUE)) {
#'   library(mlr3)
#'   library(mlr3proba)
#'   library(mlr3pipelines)
#'
#'   # encode `sex` (two-level factor)
#'   task = tsk("rats")
#'   enc = po("encode", method = "treatment")
#'   task = enc$train(list(task))[[1L]]
#'
#'   # simple filter use
#'   filter = flt("univariate_cox")
#'   filter$calculate(task)
#'   as.data.table(filter)
#'
#'   # transform to p-value
#'   10^(-filter$scores)
#'
#'   # Use filter in a learner pipeline
#'   # Note: `filter.cutoff` is selected randomly and should be tuned.
#'   # The significance level of `0.05` serves as a conventional threshold.
#'   # The filter returns the `-log10`-transformed scores so we transform
#'   # the cutoff as well:
#'   cutoff = -log10(0.05) # ~1.3
#'
#'   graph =
#'     po("filter", filter = flt("univariate_cox"), filter.cutoff = cutoff) %>>%
#'     po("learner", lrn("surv.coxph"))
#'   learner = as_learner(graph)
#'
#'   learner$train(task)
#'
#'   # univariate cox filter scores
#'   learner$model$surv.univariate_cox$scores
#'
#'   # only two features had a score larger than the specified `cutoff` and
#'   # were used to train the CoxPH model
#'   learner$model$surv.coxph$train_task$feature_names
#' }
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
      t = task$clone()
      features = t$feature_names

      scores = map_dbl(features, function(feature) {
        t$col_roles$feature = feature
        model = invoke(survival::coxph, formula = t$formula(), data = t$data())
        pval = summary(model)$coefficients[, "Pr(>|z|)"]
        -log10(pval) # smaller p-values => larger scores
      })

      set_names(scores, features)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("univariate_cox", FilterUnivariateCox)
