#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @usage NULL
#' @aliases mlr_filters_mim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterMIM$new()
#' mlr_filters$get("mim")
#' flt("mim")
#' ```
#'
#' @description Conditional mutual information based feature selection filter
#' calling [praznik::MIM()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("mim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMIM = R6Class("FilterMIM", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "mim",
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
