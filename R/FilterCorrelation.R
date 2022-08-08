#' @title Correlation Filter
#'
#' @name mlr_filters_correlation
#'
#' @description
#' Simple correlation filter calling [stats::cor()].
#' The filter score is the absolute value of the correlation.
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
#' if (requireNamespace("mlr3pipelines")) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("boston_housing")
#'
#'   graph = po("filter", filter = flt("correlation"), filter.cutoff = 0.2) %>>%
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
        use    = p_fct(c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs"), default = "everything"),
        method = p_fct(c("pearson", "kendall", "spearman"), default = "pearson")
      )

      super$initialize(
        id = "correlation",
        task_type = "regr",
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
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("correlation", FilterCorrelation)
