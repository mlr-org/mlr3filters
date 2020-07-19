#' @title Minimal Conditional Mutual Information Filter
#'
#' @name mlr_filters_cmim
#'
#' @description Minimal conditional mutual information maximisation filter
#' calling [praznik::CMIM()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("cmim")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterCMIM = R6Class("FilterCMIM",
  inherit = Filter,

  public = list(

    #' @description Create a FilterCMIM object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      ))

      super$initialize(
        id = "cmim",
        task_type = c("classif", "regr"),
        param_set = param_set,
        feature_types = c("integer", "numeric", "factor", "ordered"),
        packages = "praznik",
        man = "mlr3filters::mlr_filters_cmim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::CMIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("cmim", FilterCMIM)
