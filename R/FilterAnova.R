#' @title ANOVA F-Test Filter
#'
#' @name mlr_filters_anova
#'
#' @description ANOVA F-Test filter calling [stats::aov()]. Note that this is
#' equivalent to a \eqn{t}-test for binary classification.
#'
#' The filter value is `-log10(p)` where `p` is the \eqn{p}-value. This
#' transformation is necessary to ensure numerical stability for very small
#' \eqn{p}-values.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("iris")
#' filter = flt("anova")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
#'
#' # transform to p-value
#' 10^(-filter$scores)
FilterAnova = R6Class("FilterAnova", inherit = Filter,

  public = list(

    #' @description Create a FilterAnova object.
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
    #' @param task_properties (`character()`)\cr
    #'   Required task properties, see [mlr3::Task].
    #'   Must be a subset of
    #'   [`mlr_reflections$task_properties`][mlr3::mlr_reflections].
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    initialize = function(id = "anova",
      task_type = "classif",
      task_properties = character(),
      param_set = ParamSet$new(),
      feature_types = c("integer", "numeric"),
      packages = "stats") {
      super$initialize(
        id = id,
        packages = packages,
        feature_types = feature_types,
        task_type = task_type
      )
    }
  ),

  privat = list(

    .calculate = function(task, nfeat) {
      data = task$data()
      target = task$target_names
      features = task$feature_names
      p = map_dbl(features, function(fn) {
        f = formulate(fn, target)
        summary(aov(f, data = data))[[1L]][1L, "Pr(>F)"]
      })
      set_names(-log10(p), features)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("anova", FilterAnova)
