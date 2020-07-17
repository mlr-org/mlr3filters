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
    initialize = function(id = "jmi",
      task_type = "classif",
      param_set = ParamSet$new(list(
        ParamInt$new("threads", lower = 0L, default = 0L)
      )),
      packages = "praznik",
      feature_types = c("integer", "numeric", "factor", "ordered")) {
      super$initialize(
        id = id,
        task_type = task_type,
        param_set = param_set,
        feature_types = feature_types,
        packages = packages,
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
