#' @title Symmetrical Uncertainty Filter
#'
#' @aliases mlr_filters_symmetrical_uncertainty
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Symmetrical uncertainty filter calling [FSelectorRcpp::information_gain()] from package \CRANpkg{FSelectorRcpp}.
#' Argument `equal` defaults to `FALSE` for classification tasks, and to `TRUE` for regression tasks.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("pima")
#' filter = FilterSymmetricalUncertainty$new()
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterSymmetricalUncertainty = R6Class("FilterSymmetricalUncertainty", inherit = Filter,
  public = list(
    initialize = function(id = "symmetrical_uncertainty") {
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
    },

    calculate_internal = function(task, nfeat) {
      pv = self$param_set$values
      pv$equal = pv$equal %??% task$task_type == "regr"

      x = setDF(task$data(cols = task$feature_names))
      y = task$truth()
      scores = invoke(FSelectorRcpp::information_gain, x = x, y = y, type = "symuncert", .args = pv)
      set_names(scores$importance, scores$attributes)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("symmetrical_uncertainty", FilterSymmetricalUncertainty)
