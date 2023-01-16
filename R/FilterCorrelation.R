#' @title Correlation Filter
#'
#' @name mlr_filters_correlation
#'
#' @description
#' Simple correlation filter calling [stats::cor()].
#' The filter score is the absolute value of the correlation.
#'
#' @note
#' This filter, in its default settings, can handle missing values in the features.
#' However, the resulting filter scores may be misleading or at least difficult to compare
#' if some features have a large proportion of missing values.
#'
#' If a feature has no non-missing value, the resulting score will be `NA`.
#' Missing scores  appear in a random, non-deterministic order at the end of the vector of scores.
#'
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' ## Pearson (default)
#' task = mlr3::tsk("mtcars")
#' filter = flt("correlation")
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' ## Spearman
#' filter = FilterCorrelation$new()
#' filter$param_set$values = list("method" = "spearman")
#' filter$calculate(task)
#' as.data.table(filter)
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("boston_housing")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("correlation"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("regr.rpart"))
#'
#'   graph$train(task)
#' }
FilterCorrelation = R6Class("FilterCorrelation",
  inherit = Filter,

  public = list(

    #' @description Create a FilterCorrelation object.
    initialize = function() {
      param_set = ps(
        use    = p_fct(c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs"),
          default = "everything"),
        method = p_fct(c("pearson", "kendall", "spearman"), default = "pearson")
      )

      super$initialize(
        id = "correlation",
        task_types = "regr",
        param_set = param_set,
        feature_types = c("integer", "numeric"),
        packages = "stats",
        label = "Correlation",
        man = "mlr3filters::mlr_filters_correlation"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      fn = task$feature_names
      pv = self$param_set$values
      score = invoke(stats::cor,
        x = as.matrix(task$data(cols = fn)),
        y = as.matrix(task$truth()),
        .args = pv)[, 1L]
      set_names(abs(score), fn)
    },

    .get_properties = function() {
      "missings"
    }

  )
)

#' @include mlr_filters.R
mlr_filters$add("correlation", FilterCorrelation)
