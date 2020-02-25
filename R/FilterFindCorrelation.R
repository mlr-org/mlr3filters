#' @title Correlation Filter
#'
#' @name mlr_filters_find_correlation
#'
#' @description
#' Simple filter emulating `caret::findCorrelation(exact = FALSE)`.
#'
#' This gives each feature a score between 0 and 1 that is *one minus* the
#' cutoff value for which it is excluded when using [caret::findCorrelation()].
#' The negative is used because [caret::findCorrelation()] excludes everything
#' *above* a cutoff, while filters exclude everything below a cutoff.
#' Here the filter scores are shifted by +1 to get positive values for to align
#' with the way other filters work.
#'
#' Subsequently `caret::findCorrelation(cutoff = 0.9)` lists the same features
#' that are excluded with `FilterFindCorrelation` at score 0.1 (= 1 - 0.9).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' ## Pearson (default)
#' task = mlr3::tsk("mtcars")
#' filter = flt("find_correlation")
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' ## Spearman
#' filter = flt("find_correlation", method = "spearman")
#' filter$calculate(task)
#' as.data.table(filter)
FilterFindCorrelation = R6Class("FilterFindCorrelation", inherit = Filter,

  public = list(

    #' @description Create a FilterFindCorrelation object.
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
    initialize = function(id = "find_correlation",
      task_type = c("classif", "regr"),
      param_set = ParamSet$new(list(
        ParamFct$new("use", default = "everything",
          levels = c("everything", "all.obs", "complete.obs", "na.or.complete",
            "pairwise.complete.obs")),
        ParamFct$new("method", default = "pearson",
          levels = c("pearson", "kendall", "spearman"))
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
    }
  ),

  private = list(

    .calculate = function(task, nfeat) {

      fn = task$feature_names
      pv = self$param_set$values
      cm = invoke(stats::cor,
        x = task$data(cols = fn),
        .args = pv)
      cm = abs(cm)
      # a feature is removed as soon as it is in the higher average correlation
      # col in a pair (note: tie broken by removing /later/ feature first)
      avg_cor = colMeans(cm)
      # decreasing = TRUE to emulate tie breaking
      avg_cor_order = order(avg_cor, decreasing = TRUE)
      cm = cm[avg_cor_order, avg_cor_order, drop = FALSE]
      # Rows / Columns of cm are now ordered by correlation mean, highest first.
      # A feature i is excluded as soon as a lower-average-correlation feature
      # has correlation with i > cutoff. This means the cutoff at which i is
      # excluded is the max of the correlation with all lower-avg-cor features.
      # Therefore we look for the highest feature correlation col-wise in the
      # lower triangle of the ordered cm.

      # the lowest avg col feature is never removed by caret, so its cutoff is
      # 0.
      cm[upper.tri(cm, diag = TRUE)] = 0
      # The following has the correct names and values, BUT we need scores in
      # reverse order. Shift by 1 to get positive values.
      1 - apply(cm, 2, max)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("find_correlation", FilterFindCorrelation)
