#' @title Minimal Conditional Mutual Information Filter
#'
#' @usage NULL
#' @aliases mlr_filters_cmim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterCMIM$new()
#' mlr_filters$get("cmim")
#' flt("cmim")
#' ```
#'
#' @description Minimal conditional mutual information maximisation filter
#' calling [praznik::CMIM()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterCMIM$new()
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterCMIM = R6Class("FilterCMIM", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "cmim",
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamInt$new("threads", lower = 0L, default = 0L)
        ))
      )
    },

    calculate_internal = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::CMIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("cmim", FilterCMIM)
