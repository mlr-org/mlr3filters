#' @title Minimum redundancy maximal relevancy filter
#'
#' @aliases mlr_filters_mrmr
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Minimum redundancy maximal relevancy filter calling [praznik::MRMR()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterMRMR$new()
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMRMR = R6Class("FilterMRMR", inherit = Filter,
  public = list(
    initialize = function(id = "mrmr", param_vals = list()) {
      super$initialize(
        id = id,
        packages = "praznik",
        feature_types = c("numeric", "factor", "integer", "character", "logical"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamInt$new("threads", lower = 0L, default = 0L)
        )),
        param_vals = param_vals
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
