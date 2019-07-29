#' @title Kruskal-Wallis Test Filter
#'
#' @aliases mlr_filters_kruskal_test
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' Kruskal-Wallis rank sum test filter calling [stats::kruskal.test()].
#' The filter value is `-log10(p)` where `p` is the p-value.
#' This transformation is necessary to ensure numerical stability for very small p-values.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterKruskalTest$new()
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' # transform to p-value
#' 10^(-filter$scores)
FilterKruskalTest = R6Class("FilterKruskalTest", inherit = Filter,
  public = list(
    initialize = function(id = "kruskal_test") {
      super$initialize(
        id = id,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = "classif",
        param_set = ParamSet$new(list(
          ParamFct$new("na.action", default = "na.omit",
            levels = c("na.omit", "na.fail", "na.exclude", "na.pass"))
        ))
      )
    },

    calculate_internal = function(task, nfeat) {
      na.action = self$param_set$values$na.action %??% self$param_set$default$na.action

      data = task$data(cols = task$feature_names)
      g = task$truth()
      -log10(map_dbl(data, function(x) {
        kruskal.test(x = x, g = g, na.action = na.action)$p.value
      }))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("kruskal_test", FilterKruskalTest)
