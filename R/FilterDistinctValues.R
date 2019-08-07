#' @title Number of Distinct Values Filter
#'
#' @aliases mlr_filters_distinct_values
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Filter which scores using the number of distinct, non-missing values per feature:
#'
#' * If parameter `"method"` is set to `"count"`, just counts the number of distinct, non-missing values.
#'   This operation uses capabilities of the [mlr3::DataBackend] efficiently.
#' * If parameter `"method"` is set to `"mode"`, calculates the ratio of observations which
#'   differ from the mode value. Missing values are ignored. If all values are missing,
#'   the score is 0.
#'
#' This filter is intended to be used during preprocessing to remove features which are (nearly) constant.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr_tasks$get("pima")
#' filter = FilterDistinctValues$new()
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' filter$param_set$values = list(method = "mode")
#' filter$calculate(task)
#' as.data.table(filter)
FilterDistinctValues = R6Class("FilterDistinctValues", inherit = Filter,
  public = list(
    initialize = function(id = "distinct_values") {
      super$initialize(
        id = id,
        feature_types = c("logical", "integer", "numeric", "factor", "ordered"),
        task_type = c("classif", "regr"),
        param_set = ParamSet$new(list(
          ParamFct$new("method", default = "count", levels = c("count", "mode"), tags = "required")
        )),
        param_vals = list(method = "count")
      )
    },

    calculate_internal = function(task, nfeat) {
      method = self$param_set$values$method
      if (method == "count") {
        lengths(task$backend$distinct(task$row_ids, task$feature_names))
      } else {
        tab = task$data(cols = task$feature_names)
        map_dbl(tab, function(x) {
          mode = compute_mode(x, ties_method = "first", na_rm = TRUE)
          if (length(mode) == 0L) # all missing
            return(0)
          mean(x != mode, na.rm = TRUE)
        })
      }
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("distinct_values", FilterDistinctValues)
