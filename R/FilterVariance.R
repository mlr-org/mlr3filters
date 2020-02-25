#' @title Variance Filter
#'
#' @name mlr_filters_variance
#'
#' @description Variance filter calling [stats::var()].
#'
#' Argument `na.rm` defaults to `TRUE` here.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("variance")
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterVariance = R6Class("FilterVariance", inherit = Filter,

  public = list(

    #' @description Create a FilterVariance object.
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
    initialize = function(id = "variance",
      task_type = c("classif", "regr"),
      param_set = ParamSet$new(list(
        ParamLgl$new("na.rm", default = TRUE)
      )),
      packages = "stats",
      feature_types = c("integer", "numeric")) {
      super$initialize(
        id = id,
        task_type = task_type,
        param_set = param_set,
        feature_types = feature_types,
        packages = packages
      )
      self$param_set$values = list(na.rm = TRUE)
    }
  ),

  private = list(

    .calculate = function(task, nfeat) {
      na.rm = self$param_set$values$na.rm %??% TRUE
      map_dbl(task$data(cols = task$feature_names), var, na.rm = na.rm)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("variance", FilterVariance)
