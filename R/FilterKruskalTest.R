#' @title Kruskal-Wallis Test Filter
#'
#' @name mlr_filters_kruskal_test
#'
#' @description Kruskal-Wallis rank sum test filter calling [stats::kruskal.test()].
#'
#' The filter value is `-log10(p)` where `p` is the \eqn{p}-value. This
#' transformation is necessary to ensure numerical stability for very small
#' \eqn{p}-values.

#' @note
#' This filter, in its default settings, can handle missing values in the features.
#' However, the resulting filter scores may be misleading or at least difficult to compare
#' if some features have a large proportion of missing values.
#'
#' If a feature has not at least one non-missing observation per label, the resulting score will be NA.
#' Missing scores  appear in a random, non-deterministic order at the end of the vector of scores.
#'
#'
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @include Filter.R
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
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("kruskal_test"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterKruskalTest = R6Class("FilterKruskalTest",
  inherit = Filter,

  public = list(

    #' @description Create a FilterKruskalTest object.
    initialize = function() {
      param_set = ps(
        na.action = p_fct(c("na.omit", "na.fail", "na.exclude"), default = "na.omit")
      )

      super$initialize(
        id = "kruskal_test",
        task_types = "classif",
        param_set = param_set,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        label = "Kruskal-Wallis Test",
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
        tab = table(g[!is.na(x)])

        if (any(tab == 0L)) {
          NA_real_
        } else {
          kruskal.test(x = x, g = g, na.action = na_action)$p.value
        }
      }))
    },

    .get_properties = function() {
      ok = c("na.omit", "na.exclude")
      if ((self$param_set$values$na.action %??% "na.omit") %in% ok) "missings" else character()
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("kruskal_test", FilterKruskalTest)
