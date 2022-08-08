#' @title Information Gain Filter
#'
#' @name mlr_filters_information_gain
#'
#' @description Information gain filter calling
#'   [FSelectorRcpp::information_gain()] in package \CRANpkg{FSelectorRcpp}. Set
#'   parameter `"type"` to `"gainratio"` to calculate the gain ratio, or set to
#'   `"symuncert"` to calculate the symmetrical uncertainty (see
#'   [FSelectorRcpp::information_gain()]). Default is `"infogain"`.
#'
#'   Argument `equal` defaults to `FALSE` for classification tasks, and to
#'   `TRUE` for regression tasks.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("FSelectorRcpp")) {
#'   ## InfoGain (default)
#'   task = mlr3::tsk("pima")
#'   filter = flt("information_gain")
#'   filter$calculate(task)
#'   head(filter$scores, 3)
#'   as.data.table(filter)
#'
#'   ## GainRatio
#'
#'   filterGR = flt("information_gain")
#'   filterGR$param_set$values = list("type" = "gainratio")
#'   filterGR$calculate(task)
#'   head(as.data.table(filterGR), 3)
#'
#' }
#'
#' if (requireNamespace("mlr3pipelines") && requireNamespace("FSelectorRcpp")) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("spam")
#'
#'   graph = po("filter", filter = flt("information_gain"), filter.cutoff = 0.1) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#'
#' }
FilterInformationGain = R6Class("FilterInformationGain",
  inherit = Filter,

  public = list(

    #' @description Create a FilterInformationGain object.
    initialize = function() {
      param_set = ps(
        type         = p_fct(c("infogain", "gainratio", "symuncert"), default = "infogain"),
        equal        = p_lgl(default = FALSE),
        discIntegers = p_lgl(default = TRUE),
        threads      = p_int(lower = 0L, default = 0L, tags = "threads")
      )

      super$initialize(
        id = "information_gain",
        task_type = c("classif", "regr"),
        param_set = param_set,
        feature_types = c("integer", "numeric", "factor", "ordered"),
        packages = "FSelectorRcpp",
        label = "Information Gain",
        man = "mlr3filters::mlr_filters_information_gain"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values
      pv$type = pv$type %??% "infogain"
      pv$equal = pv$equal %??% task$task_type == "regr"

      x = setDF(task$data(cols = task$feature_names))
      y = task$truth()
      scores = invoke(FSelectorRcpp::information_gain, x = x, y = y, .args = pv)
      set_names(scores$importance, scores$attributes)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("information_gain", FilterInformationGain)
