#' @title Information Gain Filter
#'
#' @aliases mlr_filters_information_gain
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Information gain filter calling [FSelectorRcpp::information_gain()] in package \CRANpkg{FSelectorRcpp}.
#' Argument `equal` defaults to `FALSE` for classification tasks, and to `TRUE` for regression tasks.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("pima")
#' filter = FilterInformationGain$new()
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterInformationGain = R6Class("FilterInformationGain", inherit = Filter,
  public = list(
    initialize = function(id = "information_gain") {
      super$initialize(
        id = id,
        packages = "FSelectorRcpp",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamLgl$new("equal", default = FALSE),
          ParamLgl$new("discIntegers", default = TRUE),
          ParamInt$new("threads", lower = 0L, default = 1L)
        ))
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values
      pv$equal = pv$equal %??% task$task_type == "regr"

      x = setDF(task$data(cols = task$feature_names))
      y = task$truth()
      scores = invoke(FSelectorRcpp::information_gain, x = x, y = y, type = "infogain", .args = pv)
      set_names(scores$importance, scores$attributes)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("information_gain", FilterInformationGain)
