#' @title Minimal Joint Mutual Information Maximisation Filter
#'
#' @name mlr_filters_jmim
#'
#' @description Minimal joint mutual information maximisation filter calling
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
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("jmim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
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
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
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
