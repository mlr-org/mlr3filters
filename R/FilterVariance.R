#' @title Variance Filter
#'
#' @name mlr_filters_variance
#'
#' @description Variance filter calling `stats::var()`.
#'
#' Argument `na.rm` defaults to `TRUE` here.
#'
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @importFrom stats var
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("variance")
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
#'
#' if (requireNamespace("mlr3pipelines")) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   # Note: The filter.frac is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("variance"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterVariance = R6Class("FilterVariance",
  inherit = Filter,

  public = list(

    #' @description Create a FilterVariance object.
    initialize = function() {
      param_set = ps(
        na.rm = p_lgl(default = TRUE)
      )
      self$param_set$values = list(na.rm = TRUE)

      super$initialize(
        id = "variance",
        task_type = NA_character_,
        param_set = param_set,
        packages = "stats",
        feature_types = c("integer", "numeric"),
        label = "Variance",
        man = "mlr3filters::mlr_filters_variance"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      na_rm = self$param_set$values$na.rm %??% TRUE
      map_dbl(task$data(cols = task$feature_names), var, na.rm = na_rm)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("variance", FilterVariance)
