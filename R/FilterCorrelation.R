#' @title Correlation Filter
#'
#' @usage NULL
#' @name mlr_filters_correlation
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterCorrelation$new()
#' mlr_filters$get("correlation")
#' flt("correlation")
#' ```
#'
#' @description
#' Simple correlation filter calling [stats::cor()].
#' The filter score is the absolute value of the correlation.
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
FilterCorrelation = R6Class("FilterCorrelation", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "correlation",
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = "regr",
        param_set = ParamSet$new(list(
          ParamFct$new("use", default = "everything",
            levels = c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs")),
          ParamFct$new("method", default = "pearson",
            levels = c("pearson", "kendall", "spearman"))
        ))
      )
    },

    calculate_internal = function(task, nfeat) {
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
