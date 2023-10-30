#' @title Univariate Cox Survival Filter
#'
#' @name mlr_filters_univariatecox
#'
#' @description Calculates scores for assessing the relationship between
#' individual features and the time-to-event outcome (right-censored survival
#' data) using a univariate Cox proportional hazards model.
#' The goal is to determine which features have a statistically significant
#' association with the event of interest, typically in the context of clinical
#' or biomedical research.
#'
#' This filter fits a [CoxPH][mlr3proba::LearnerSurvCoxPH()] learner using each
#' feature independently and extracts the \eqn{p}-value that quantifies the
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
#' if (requireNamespace("mlr3proba")) {
#'   task = tsk("rats")$select(c("rx","litter"))
#'   filter = flt("univariatecox")
#'   filter$calculate(task)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "mlr3proba"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = tsk("rats")
#'   # encode `sex` which is a two-level factor
#'   enc = po("encode", method = "treatment")
#'   task = enc$train(list(task))[[1L]]
#'
#'   # Note: `filter.cutoff` is selected randomly and should be tuned.
#'   # The significance level of `0.05` serves as a conventional threshold.
#'   # The filter returns the `-log`-transformed scores so we transform
#'   # the cutoff as well:
#'   cutoff = -log(0.05) # ~2.99
#'
#'   graph =
#'     po("filter", filter = flt("univariatecox"), filter.cutoff = cutoff) %>>%
#'     po("learner", lrn("surv.coxph"))
#'   learner = as_learner(graph)
#'
#'   learner$train(task)
#'
#'   # univariate cox filter scores
#'   learner$model$surv.univariatecox$scores
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
        id = "surv.univariatecox",
        packages = c("mlr3proba"),
        param_set = ps(),
        feature_types = c("integer", "numeric"),
        task_types = "surv",
        label = "Univariate Cox Survival Score",
        man = "mlr3filters::mlr_filters_univariatecox"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      t = task$clone()
      features = t$feature_names
      learner = lrn("surv.coxph")

      scores = map_dbl(features, function(feature) {
        t$col_roles$feature = feature
        learner$train(t)
        pval = summary(learner$model)$coefficients[, "Pr(>|z|)"]
        -log(pval) # smaller p-values => larger scores
      })

      set_names(scores, features)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("univariatecox", FilterUnivariateCox)
