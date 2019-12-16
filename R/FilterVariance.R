#' @title Variance Filter
#'
#' @usage NULL
#' @name mlr_filters_variance
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterVariance$new()
#' mlr_filters$get("variance")
#' flt("variance")
#' ```
#'
#' @description Variance filter calling [stats::var()].
#'
#' Argument `na.rm` defaults to `TRUE` here.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("variance")
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterVariance = R6Class("FilterVariance", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "variance",
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamLgl$new("na.rm", default = TRUE)
        ))
      )
      self$param_set$values = list(na.rm = TRUE)
    },

    calculate_internal = function(task, nfeat) {
      na.rm = self$param_set$values$na.rm %??% TRUE
      map_dbl(task$data(cols = task$feature_names), var, na.rm = na.rm)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("variance", FilterVariance)
