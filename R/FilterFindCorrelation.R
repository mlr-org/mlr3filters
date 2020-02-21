#' @title Correlation Filter
#'
#' @usage NULL
#' @name mlr_filters_correlation
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterFindCorrelation$new()
#' mlr_filters$get("findcorrelation")
#' flt("findcorrelation")
#' ```
#'
#' @description
#' Simple filter emulating `caret::findCorrelation(exact = FALSE_)`.
#' 
#' This gives each feature a score between 0 and 1 that is *one minus* the cutoff value
#' for which it is excluded when using `caret::findCorrelation()`. The negative
#' is used because `caret::findCorrelation()` excludes everything *above* a cutoff,
#' while filters exclude everything below a cutoff; this is shifted by +1 to get
#' positive values for aesthetics. Therefore, `caret::findCorrelation(cutoff = 0.9)`
#' lists the same features that are excluded with `FilterFindCorrelation` at score 0.1 ( = 1 - 0.9).
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' ## Pearson (default)
#' task = mlr3::tsk("mtcars")
#' filter = flt("findcorrelation")
#' filter$calculate(task)
#' as.data.table(filter)
#'
#' ## Spearman
#' filter = FilterFindCorrelation$new()
#' filter$param_set$values = list("method" = "spearman")
#' filter$calculate(task)
#' as.data.table(filter)
FilterFindCorrelation = R6Class("FilterFindCorrelation", inherit = Filter,
  public = list(
    initialize = function() {
      super$initialize(
        id = "correlation",
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = mlr_reflections$task_types$type,  # basically any task
        param_set = ParamSet$new(list(
          ParamFct$new("use", default = "everything",
            levels = c("everything", "all.obs", "complete.obs", "na.or.complete", "pairwise.complete.obs")),
          ParamFct$new("method", default = "pearson",
            levels = c("pearson", "kendall", "spearman"))
        ))
      )
    },

    calculate_internal = function(task, nfeat) {
      fn = task$feature_names
      pv = self$param_set$values
      cm = invoke(stats::cor,
        x = task$data(cols = fn),
        .args = pv)
      cm = abs(cm)
      # a feature is removed as soon as it is in the higher average correlation col in a pair
      # (note: tie broken by removing /later/ feature first)
      avg_cor = colMeans(cm)
      avg_cor_order = order(avg_cor, decreasing = TRUE)  # decreasing = TRUE to emulate tie breaking
      cm = cm[avg_cor_order, avg_cor_order, drop = FALSE]
      # Rows / Columns of cm are now ordered by correlation mean, highest first.
      # A feature i is excluded as soon as a lower-average-correlation feature has correlation with i > cutoff.
      # This means the cutoff at which i is excluded is the max of the correlation with all lower-avg-cor features.
      # Therefore we look for the highest feature correlation col-wise in the lower triangle of the ordered cm.
      cm[upper.tri(cm, diag = TRUE)] = 0  # the lowest avg col feature is never removed by caret, so its cutoff is 0.
      # The following has the correct names and values, BUT we need scores in reverse order. Shift by 1 to get +ve values.
      1 - apply(cm, 2, max)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("findcorrelation", FilterFindCorrelation)

