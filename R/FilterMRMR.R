#' @title Minimum redundancy maximal relevancy filter
#'
#' @usage NULL
#' @aliases mlr_filters_mrmr
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterMRMR$new()
#' mlr_filters$get("mrmr")
#' flt("mrmr")
#' ```
#'
#' @description Minimum redundancy maximal relevancy filter calling
#' [praznik::MRMR()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = tsk("iris")
#' filter = flt("mrmr")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMRMR = R6Class("FilterMRMR", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "mrmr",
        packages = "praznik",
        feature_types = c("numeric", "factor", "integer", "character", "logical"),
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
      praznik::MRMR(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("mrmr", FilterMRMR)
