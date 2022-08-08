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
#' @references
#' For a benchmark of filter methods:
#'
#' `r format_bib("bommert_2020")`
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("pima")
#' filter = flt("auc")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
#'
#' if (requireNamespace("mlr3pipelines")) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   graph = po("filter", filter = flt("auc"), filter.cutoff = 0.1) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterAUC = R6Class("FilterAUC",
  inherit = Filter,

  public = list(

    #' @description Create a FilterAUC object.
    initialize = function() {
      super$initialize(
        id = "auc",
        task_type = "classif",
        task_properties = "twoclass",
        feature_types = c("integer", "numeric"),
        packages = "mlr3measures",
        label = "Area Under the ROC Curve Score",
        man = "mlr3filters::mlr_filters_auc"
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
