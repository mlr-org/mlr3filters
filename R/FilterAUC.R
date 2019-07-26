#' @title AUC Filter
#'
#' @aliases mlr_filters_auc
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Area under the (ROC) Curve filter calling [Metrics::auc()] from package \CRANpkg{Metrics}.
#' Returns the absolute value of the difference between the AUC and 0.5.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("pima")
#' filter = FilterAUC$new()
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterAUC = R6Class("FilterAUC", inherit = Filter,
  public = list(
    initialize = function(id = "auc") {
      super$initialize(
        id = id,
        packages = "Metrics",
        feature_types = c("integer", "numeric"),
        task_type = "classif",
        task_properties = "twoclass"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      x = task$truth() == task$positive
      y = task$data(cols = task$feature_names)
      score = map_dbl(y, function(y) Metrics::auc(x, y))
      abs(0.5 - score)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("auc", FilterAUC)
