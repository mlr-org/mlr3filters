#' @title RELIEF Filter
#'
#' @name mlr_filters_relief
#'
#' @description Information gain filter calling
#'   [FSelectorRcpp::relief()] in package \CRANpkg{FSelectorRcpp}.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("FSelectorRcpp")) {
#'   ## Relief (default)
#'   task = mlr3::tsk("pima")
#'   filter = flt("relief")
#'   filter$calculate(task)
#'   head(filter$scores, 3)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "FSelectorRcpp", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("iris")
#'
#'   # Note: `filter.frac` is selected randomly and should be tuned.
#'
#'   graph = po("filter", filter = flt("relief"), filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterRelief = R6Class("FilterRelief",
  inherit = Filter,

  public = list(

    #' @description Create a FilterRelief object.
    initialize = function() {
      param_set = ps(
        neighboursCount = p_int(lower = 1L, default = 5L),
        sampleSize      = p_int(lower = 1L, default = 10L)
      )

      super$initialize(
        id = "relief",
        task_type = c("classif", "regr"),
        param_set = param_set,
        feature_types = c("integer", "numeric", "factor", "ordered"),
        packages = "FSelectorRcpp",
        label = "RELIEF",
        man = "mlr3filters::mlr_filters_relief"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values

      x = setDF(task$data(cols = task$feature_names))
      y = task$truth()
      scores = invoke(FSelectorRcpp::relief, x = x, y = y, .args = pv)
      set_names(scores$importance, scores$attributes)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("relief", FilterRelief)
