#' @title Minimal Joint Mutual Information Maximisation Filter
#'
#' @aliases mlr_filters_jmim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description Minimal joint mutual information maximisation filter. Calls
#'   [praznik::JMIM()].
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
#' filter = FilterJMIM$new()
#' filter$calculate(task)
#' as.data.table(filter)[1:3]
FilterJMIM = R6Class("FilterJMIM", inherit = Filter,
  public = list(
    initialize = function(id = "jmim", param_vals = list()) {
      super$initialize(
        id = id,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        task_type = "classif",
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

      praznik::JMIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)
