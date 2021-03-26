#' @title Double Input Symmetrical Relevance Filter
#'
#' @name mlr_filters_disr
#'
#' @description Double input symmetrical relevance filter calling
#' [praznik::DISR()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @template details_praznik
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("disr")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterDISR = R6Class("FilterDISR",
  inherit = Filter,

  public = list(

    #' @description Create a FilterDISR object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L, tags = "threads")
      ))
      param_set$values = list(threads = 1L)

      super$initialize(
        id = "disr",
        task_type = c("classif", "regr"),
        param_set = param_set,
        feature_types = c("integer", "numeric", "factor", "ordered"),
        packages = "praznik",
        man = "mlr3filters::mlr_filters_disr"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::DISR, nfeat)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("disr", FilterDISR)
