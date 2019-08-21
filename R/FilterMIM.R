#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @aliases mlr_filters_mim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description Conditional mutual information based feature selection filter
#' calling [praznik::MIM()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterMIM$new()
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMIM = R6Class("FilterMIM", inherit = Filter,
  public = list(
    initialize = function(id = "mim") {
      super$initialize(
        id = id,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        task_type = "classif",
        param_set = ParamSet$new(list(
          ParamInt$new("threads", lower = 0L, default = 0L)
        ))
      )
    },

    calculate_internal = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::MIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("mim", FilterMIM)
