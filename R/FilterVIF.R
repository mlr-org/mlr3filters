#' @title VIF Filter
#'
#' @name mlr_filters_vif
#'
#' @description
#' #FIXME:
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' task = mlr3::tsk("mtcars")
#' filter = flt("vic")
#' filter$calculate(task)
#' head(as.data.table(filter), 3)
FilterVIC = R6Class("FilterVIC",
  inherit = Filter,

  public = list(

    #' @description Create a FilterAUC object.
    initialize = function() {
      super$initialize(
        id = "vic",
        task_type = "regr",
        feature_types = c("logical", "integer", "numeric", "factor"),
        packages = c("car", "mlr3measures"),
        man = "mlr3filters::mlr_filters_vic"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      mod = invoke(stats::lm, formula = task$formula(), data = task$data())
      negative_vic = - invoke(car::vif, mod = mod)
      negative_vic
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("vic", FilterVIC)

