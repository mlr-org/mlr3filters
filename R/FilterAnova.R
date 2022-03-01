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
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @importFrom stats aov
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
FilterAnova = R6Class("FilterAnova",
  inherit = Filter,

  public = list(

    #' @description Create a FilterAnova object.
    initialize = function() {
      super$initialize(
        id = "anova",
        packages = "stats",
        feature_types = c("integer", "numeric"),
        task_type = "classif",
        label = "ANOVA F-Test",
        man = "mlr3filters::mlr_filters_anova"
      )
    }
  ),

  private = list(
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
