#' @title AUC Filter
#'
#' @usage NULL
#' @aliases mlr_filters_auc
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterAUC$new()
#' mlr_filters$get("auc")
#' flt("auc")
#' ```
#'
#' @description Area under the (ROC) Curve filter calling [Metrics::auc()] from
#' package \CRANpkg{Metrics}. Returns the absolute value of the difference
#' between the AUC and 0.5.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = tsk("pima")
#' filter = flt("auc")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
FilterAUC = R6Class("FilterAUC", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "auc",
        packages = "Metrics",
        feature_types = c("integer", "numeric"),
        task_type = "classif",
        task_properties = "twoclass"
      )
    },

    calculate_internal = function(task, nfeat) {
      x = task$truth() == task$positive
      y = task$data(cols = task$feature_names)
      score = map_dbl(y, function(y) Metrics::auc(x, y))
      abs(0.5 - score)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("auc", FilterAUC)
