#' @title Minimal Conditional Mutual Information Filter
#'
#' @aliases mlr_filters_cmim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description Minimal conditional mutual information maximisation filter.
#'   Calls [praznik::CMIM()].
#'
#' @details This filter supports partial scoring via hyperparameter `k`. For
#'   internal reasons, `k` is not exposed in the ParamSet. Instead, the generic
#'   hyperparameter `nfeat` will be populated to the filter for partial scoring
#'   calculation. By default all filter values are calculated (`nfeat = 1`).
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterCMIM$new()
#' filter$calculate(task)
#'
#' ## get names of n best features
#' filter$get_best(2)
#'
#' ## get numeric filter scores
#' as.data.table(filter)[1:3]
FilterCMIM = R6Class("FilterCMIM", inherit = Filter,
  public = list(
    initialize = function(id = "cmim", param_vals = list()) {
      super$initialize(
        id = id,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamInt$new("threads", lower = 0L, default = 0L, tags = "filter")
        )),
        param_vals = param_vals
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      if (!is.null(self$param_set$get_values()$threads)) {
        threads = self$param_set$get_values()$threads
      } else {
        threads = self$param_set$default$threads
      }

      X = task$data(cols = task$feature_names)
      Y = task$truth()

      praznik::CMIM(X = X, Y = Y, k = nfeat, threads = threads)$score

    }
  )
)

register_filter("cmim", FilterCMIM)
