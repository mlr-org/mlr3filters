#' @title Minimal Normalised Joint Mutual Information Maximisation Filter
#'
#' @name mlr_filters_njmim
#'
#' @description Minimal normalised joint mutual information maximisation filter
#' calling [praznik::NJMIM()] from package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
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
        ParamInt$new("threads", lower = 0L, default = 0L)
      ))
      super$initialize(
        id = "njmim",
        task_type = "classif",
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_njmim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      reencode_praznik_score(praznik::NJMIM(X = X, Y = Y, k = nfeat, threads = threads))
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("njmim", FilterNJMIM)
