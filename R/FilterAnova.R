#' @title ANOVA F-Test Filter
#'
#' @usage NULL
#' @name mlr_filters_anova
#' @format [R6::R6Class] inheriting from [Filter].
#' @include Filter.R
#'
#' @section Construction:
#' ```
#' FilterAnova$new()
#' mlr_filters$get("anova")
#' flt("anova")
#' ```
#'
#' @description ANOVA F-Test filter calling [stats::aov()]. Note that this is
#' equivalent to a \eqn{t}-test for binary classification.
#'
#' The filter value is `-log10(p)` where `p` is the \eqn{p}-value. This transformation
#' is necessary to ensure numerical stability for very small \eqn{p}-values.
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
    initialize = function() {
      super$initialize(
        id = "anova",
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
