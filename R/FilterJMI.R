#' @title Joint Mutual Information Filter
#'
#' @usage NULL
#' @aliases mlr_filters_jmi
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterJMI$new()
#' mlr_filters$get("jmi")
#' flt("jmi")
#' ```
#'
#' @description Joint mutual information filter calling [praznik::JMI()] in
#' package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = tsk("iris")
#' filter = flt("jmi")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterJMI = R6Class("FilterJMI", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "jmi",
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
      praznik::JMI(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("jmi", FilterJMI)
