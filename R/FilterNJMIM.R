#' @title Minimal Normalised Joint Mutual Information Maximisation Filter
#'
#' @name mlr_filters_njmim
#'
#' @description Minimal normalised joint mutual information maximisation filter
#' calling [praznik::NJMIM()] from package \CRANpkg{praznik}.
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
#' filter = flt("njmim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterNJMIM = R6Class("FilterNJMIM",
  inherit = Filter,

  public = list(

    #' @description Create a FilterNJMIM object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L, tags = "threads")
      ))
      param_set$values = list(threads = 1L)
      super$initialize(
        id = "njmim",
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_njmim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::NJMIM, nfeat)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("njmim", FilterNJMIM)
