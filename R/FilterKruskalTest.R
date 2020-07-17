#' @title Kruskal-Wallis Test Filter
#'
#' @name mlr_filters_kruskal_test
#'
#' @description Kruskal-Wallis rank sum test filter calling
#'   [stats::kruskal.test()].
#'
#' The filter value is `-log10(p)` where `p` is the \eqn{p}-value. This
#' transformation is necessary to ensure numerical stability for very small
#' \eqn{p}-values.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("kruskal_test")
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' # transform to p-value
#' 10^(-filter$scores)
FilterKruskalTest = R6Class("FilterKruskalTest",
  inherit = Filter,

  public = list(

    #' @description Create a FilterKruskalTest object.
    #' @param id (`character(1)`)\cr
    #'   Identifier for the filter.
    #' @param task_type (`character()`)\cr
    #'   Types of the task the filter can operator on. E.g., `"classif"` or
    #'   `"regr"`.
    #' @param param_set ([paradox::ParamSet])\cr
    #'   Set of hyperparameters.
    #' @param feature_types (`character()`)\cr
    #'   Feature types the filter operates on.
    #'   Must be a subset of
    #'   [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    initialize = function(id = "kruskal_test",
      task_type = "classif",
      param_set = ParamSet$new(list(
        ParamFct$new("na.action",
          default = "na.omit",
          levels = c("na.omit", "na.fail", "na.exclude", "na.pass"))
      )),
      packages = "stats",
      feature_types = c("integer", "numeric")) {
      super$initialize(
        id = id,
        task_type = task_type,
        param_set = param_set,
        feature_types = feature_types,
        packages = packages,
        man = "mlr3filters::mlr_filters_kruskal_test"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      na_action = self$param_set$values$na.action %??%
        self$param_set$default$na.action

      data = task$data(cols = task$feature_names)
      g = task$truth()
      -log10(map_dbl(data, function(x) {
        kruskal.test(x = x, g = g, na.action = na_action)$p.value
      }))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("kruskal_test", FilterKruskalTest)
