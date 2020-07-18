#' @title Minimum redundancy maximal relevancy filter
#'
#' @name mlr_filters_mrmr
#'
#' @description Minimum redundancy maximal relevancy filter calling
#' [praznik::MRMR()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
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
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      ))

      super$initialize(
        id = "mrmr",
        task_type = "classif",
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_mrmr"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::MRMR(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("mrmr", FilterMRMR)
