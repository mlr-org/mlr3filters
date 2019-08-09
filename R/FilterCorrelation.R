#' @title Correlation Filter
#'
#' @aliases mlr_filters_correlation
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Simple correlation filter calling [stats::cor()].
#' The filter score is the absolute value of the correlation.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("mtcars")
#' filter = FilterCorrelation$new()
#' filter$calculate(task)
#' as.data.table(filter)
FilterCorrelation = R6Class("FilterCorrelation", inherit = Filter,
  public = list(
    initialize = function(id = "correlation", param_vals = list()) {
      super$initialize(
        id = id,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = "regr",
        param_set = ParamSet$new(list(
          ParamFct$new("use", default = "everything",
            levels = c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs")),
          ParamFct$new("method", default = "pearson",
            levels = c("pearson", "kendall", "spearman"))
        )),
        param_vals = param_vals
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
