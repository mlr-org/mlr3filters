#' @title Conditional Mutual Information Based Feature Selection Filter
#'
#' @name mlr_filters_mim
#'
#' @description Conditional mutual information based feature selection filter
#' calling [praznik::MIM()] in package \CRANpkg{praznik}.
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
#' filter = flt("mim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterMIM = R6Class("FilterMIM",
  inherit = Filter,

  public = list(

    #' @description Create a FilterMIM object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L, tags = "threads")
      ))
      param_set$values = list(threads = 1L)

      super$initialize(
        id = "mim",
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_mim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::MIM, nfeat)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("mim", FilterMIM)
