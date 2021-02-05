#' @title Joint Mutual Information Filter
#'
#' @name mlr_filters_jmi
#'
#' @description Joint mutual information filter calling [praznik::JMI()] in
#' package \CRANpkg{praznik}.
#'
#' This filter supports partial scoring (see [Filter]).
#'
#' @template details_praznik
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
        ParamInt$new("threads", lower = 0L, default = 0L, tags = "threads")
      ))
      param_set$values = list(threads = 1L)

      super$initialize(
        id = "jmi",
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "praznik",
        feature_types = c("integer", "numeric", "factor", "ordered"),
        man = "mlr3filters::mlr_filters_jmi"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      call_praznik(self, task, praznik::JMI)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("jmi", FilterJMI)
