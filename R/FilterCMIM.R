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
FilterCMIM = R6Class("FilterCMIM", inherit = Filter,

  public = list(

    #' @description Create a FilterCMIM object.
    #' @param id (`character(1)`)\cr
    #'   Identifier for the filter.
    #' @param task_type (`character()`)\cr
    #'   Types of the task the filter can operator on. E.g., `"classif"` or
    #'   `"regr"`.
    #' @param param_set ([paradox::ParamSet])\cr
    #'   Set of hyperparameters.
    #' @param feature_types (`character()`)\cr
    #'   Feature types the filter operates on.
    #'   Must be a subset of
    #'   [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    initialize = function(id = "cmim",
      task_type = c("classif", "regr"),
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      )),
      feature_types = c("integer", "numeric", "factor", "ordered"),
      packages = "praznik") {
      super$initialize(
        id = id,
        task_type = task_type,
        param_set = param_set,
        feature_types = feature_types,
        packages = packages,
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
