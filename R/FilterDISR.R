#' @title Double Input Symmetrical Relevance Filter
#'
#' @aliases mlr_filters_disr
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Double input symmetrical relevance filter calling [praznik::DISR()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterDISR$new()
#' filter$calculate(task, nfeat = 2)
#' head(filter$scores, 2)
#' as.data.table(filter)
FilterDISR = R6Class("FilterDISR", inherit = Filter,
  public = list(
    initialize = function(id = "disr") {
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
      praznik::DISR(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("disr", FilterDISR)
