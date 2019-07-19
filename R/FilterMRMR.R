#' @title Minimum redundancy maximal relevancy filter
#'
#' @aliases mlr_filters_MRMR
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description Minimum redundancy maximal relevancy filter. Calls
#'   [praznik::MRMR()].
#'
#' @details This filter supports partial scoring via hyperparameter `k`. For
#'   internal reasons, `k` is not exposed in the ParamSet. Instead, the generic
#'   hyperparameter `nfeat` will be populated to the filter for partial scoring
#'   calculation. By default all filter values are calculated (`nfeat = 1`)
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterMRMR$new()
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
FilterMRMR = R6Class("FilterMRMR", inherit = Filter,
  public = list(
    initialize = function(id = "MRMR", param_vals = list()) {
      super$initialize(
        id = id,
        packages = "praznik",
        feature_types = c("numeric", "factor", "integer", "character", "logical"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamInt$new("k", lower = 1L, default = 3L, tags = "filter"),
          ParamInt$new("threads", lower = 0L, default = 0L, tags = "filter")
        )),
        param_vals = param_vals
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat = NULL) {
      if (!is.null(self$param_set$get_values()$threads)) {
        threads = self$param_set$get_values()$threads
      } else {
        threads = self$param_set$default$threads
      }

      X = task$data(cols = task$feature_names)
      Y = task$truth()

      praznik::MRMR(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)
