#' @title Minimum redundancy maximal relevancy filter
#'
#' @name mlr_filters_mrmr
#'
#' @description Minimum redundancy maximal relevancy filter calling
#' [praznik::MRMR()] in package \CRANpkg{praznik}.
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
#' filter = flt("mrmr")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMRMR = R6Class("FilterMRMR",
  inherit = Filter,

  public = list(

    #' @description Create a FilterMRMR object.
    initialize = function() {
      param_set = ps(
        threads = p_int(lower = 0L, default = 0L, tags = "threads")
      )
      param_set$values = list(threads = 1L)

      super$initialize(
        id = "mrmr",
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_mrmr"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::MRMR, nfeat)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("mrmr", FilterMRMR)
