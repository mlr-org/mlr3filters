#' @title ANOVA F-Test Filter
#'
#' @aliases mlr_filters_anova
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @description
#' ANOVA F-Test filter calling [stats::aov()].
#' Note that this is equivalent to a t-test for binary classification.
#'
#' The filter value is `-log10(p)` where `p` is the p-value.
#' This transformation is necessary to ensure numerical stability for very small p-values.
#'
#' @family Filter
#' @export
#' @examples
#' task = mlr3::mlr_tasks$get("iris")
#' filter = FilterAnova$new()
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
#'
#' # transform to p-value
#' 10^(-filter$scores)
FilterAnova = R6Class("FilterAnova", inherit = Filter,
  public = list(
    initialize = function(id = "anova") {
      super$initialize(
        id = id,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = "classif"
      )
    },

    calculate_internal = function(task, nfeat) {
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
