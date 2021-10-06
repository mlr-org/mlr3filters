#' @title Kruskal-Wallis Test Filter
#'
#' @name mlr_filters_kruskal_test
#'
#' @description Kruskal-Wallis rank sum test filter calling [stats::kruskal.test()].
#'
#' The filter value is `-log10(p)` where `p` is the \eqn{p}-value. This
#' transformation is necessary to ensure numerical stability for very small
#' \eqn{p}-values.
#'
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @importFrom stats kruskal.test
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
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamFct$new("na.action",
          default = "na.omit",
          levels = c("na.omit", "na.fail", "na.exclude", "na.pass"))
      ))

      super$initialize(
        id = "kruskal_test",
        task_type = "classif",
        param_set = param_set,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        man = "mlr3filters::mlr_filters_kruskal_test"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      na_action = self$param_set$values$na.action %??% "na.omit"

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
