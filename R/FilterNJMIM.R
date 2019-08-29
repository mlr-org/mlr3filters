#' @title Minimal Normalised Joint Mutual Information Maximisation Filter
#'
#' @usage NULL
#' @aliases mlr_filters_njmim
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterNJMIM$new()
#' mlr_filters$get("njmim")
#' flt("njmim")
#' ```
#'
#' @description Minimal normalised joint mutual information maximisation filter
#' calling [praznik::NJMIM()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("njmim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterNJMIM = R6Class("FilterNJMIM", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "njmim",
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
      praznik::NJMIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("njmim", FilterNJMIM)
