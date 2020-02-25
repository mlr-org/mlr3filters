#' @title AUC Filter
#'
#' @name mlr_filters_auc
#'
#' @description
#' Area under the (ROC) Curve filter, analogously to [mlr3measures::auc()] from
#' \CRANpkg{mlr3measures}. Missing values of the features are removed before
#' calculating the AUC. If the AUC is undefined for the input, it is set to 0.5
#' (random classifier). The absolute value of the difference between the AUC and
#' 0.5 is used as final filter value.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("pima")
#' filter = flt("auc")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
FilterAUC = R6Class("FilterAUC", inherit = Filter,

  public = list(

    #' @description Create a FilterAUC object.
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
    initialize = function(id = "auc",
      task_type = "classif",
      task_properties = "twoclass",
      param_set = ParamSet$new(),
      packages = "mlr3measures",
      feature_types = c("integer", "numeric")) {
      super$initialize(
        id = id,
        task_type = task_type,
        task_properties = task_properties,
        feature_types = feature_types,
        packages = packages
      )
    }
  ),

  private = list(

    .calculate = function(task, nfeat) {
      y = task$truth() == task$positive
      x = task$data(cols = task$feature_names)
      score = map_dbl(x, function(x) {
        keep = !is.na(x)
        auc(y[keep], x[keep])
      })
      abs(0.5 - score)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("auc", FilterAUC)


auc = function(truth, prob) {
  n_pos = sum(truth)
  n_neg = length(truth) - n_pos
  if (n_pos == 0L || n_neg == 0L) {
    return(0.5) # nocov
  }
  r = rank(prob, ties.method = "average")
  (sum(r[truth]) - n_pos * (n_pos + 1L) / 2L) / (n_pos * n_neg)
}
