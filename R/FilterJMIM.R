#' @title Minimal Joint Mutual Information Maximization Filter
#'
#' @name mlr_filters_jmim
#'
#' @description Minimal joint mutual information maximization filter calling
#' [praznik::JMIM()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @references
#' `r format_bib("kursa_2021")`
#'
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @template details_praznik
#' @family Filter
#' @include Filter.R
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("praznik")) {
#'   task = mlr3::tsk("iris")
#'   filter = flt("jmim")
#'   filter$calculate(task, nfeat = 2)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart", "praznik"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("jmim"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterJMIM = R6Class("FilterJMIM",
  inherit = Filter,

  public = list(

    #' @description Create a FilterJMIM object.
    initialize = function() {
      param_set = ps(
        threads = p_int(lower = 0L, default = 0L, tags = "threads")
      )
      param_set$values = list(threads = 1L)
      super$initialize(
        id = "jmim",
        task_types = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        label = "Minimal Joint Mutual Information Maximization",
        man = "mlr3filters::mlr_filters_jmim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::JMIM, nfeat)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("jmim", FilterJMIM)
