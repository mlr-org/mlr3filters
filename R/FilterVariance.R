#' @title Variance Filter
#'
#' @name mlr_filters_variance
#'
#' @description Variance filter calling `stats::var()`.
#'
#' Argument `na.rm` defaults to `TRUE` here.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("variance")
#' filter$calculate(task)
#' head(filter$scores, 3)
#' as.data.table(filter)
FilterVariance = R6Class("FilterVariance",
  inherit = Filter,

  public = list(

    #' @description Create a FilterVariance object.
    initialize = function() {
      param_set = ParamSet$new(list(
        ParamLgl$new("na.rm", default = TRUE)
      ))
      self$param_set$values = list(na.rm = TRUE)

      super$initialize(
        id = "variance",
        task_type = c("classif", "regr"),
        param_set = param_set,
        packages = "stats",
        feature_types = c("integer", "numeric"),
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
