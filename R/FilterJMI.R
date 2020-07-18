#' @title Joint Mutual Information Filter
#'
#' @name mlr_filters_jmi
#'
#' @description Joint mutual information filter calling [praznik::JMI()] in
#' package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("jmi")
#' filter$calculate(task, nfeat = 2)
#' as.data.table(filter)
FilterJMI = R6Class("FilterJMI",
  inherit = Filter,

  public = list(

    #' @description Create a FilterJMI object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      ))

      super$initialize(
        id = "jmi",
        task_type = "classif",
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_jmi"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      threads = self$param_set$values$threads %??% 0L
      X = task$data(cols = task$feature_names)
      Y = task$truth()
      praznik::JMI(X = X, Y = Y, k = nfeat, threads = threads)$score
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("jmi", FilterJMI)
