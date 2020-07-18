#' @title Minimal Joint Mutual Information Maximisation Filter
#'
#' @name mlr_filters_jmim
#'
#' @description Minimal joint mutual information maximisation filter calling
#' [praznik::JMIM()] in package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
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

      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      ))
      super$initialize(
        id = "jmim",
        task_type = "classif",
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_jmim"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::JMIM(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("jmim", FilterJMIM)
