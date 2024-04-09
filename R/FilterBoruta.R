#' @title Burota Filter
#'
#' @name mlr_filters_boruta
#'
#' @description
#' Filter using the Boruta algorithm for feature selection.
#' If `keep = "tentative"`, confirmed and tentative features are returned.
#' Note that there is no ordering in the selected features.
#' Selected features get a score of 1, deselected features get a score of 0.
#' The order of selected features is random.
#' In combination with \CRANpkg{mlr3pipelines}, only the filter criterion `cutoff` makes sense.
#'
#' @references
#' `r format_bib("kursa_2010")`
#'
#' @family Filter
#' @include Filter.R
#' @template seealso_filter
#' @export
#' @examples
#' \donttest{
#'   if (requireNamespace("Boruta")) {
#'    task = mlr3::tsk("sonar")
#'    filter = flt("boruta")
#'    filter$calculate(task)
#'    as.data.table(filter)
#'   }
#' }

FilterBoruta = R6Class("FilterBoruta",
  inherit = Filter,

  public = list(

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function() {

      param_set = ps(
        pValue = p_dbl(default = 0.01),
        mcAdj = p_lgl(default = TRUE),
        maxRuns = p_int(lower = 1, default = 100),
        doTrace = p_int(lower = 0, upper = 4, default = 0),
        holdHistory = p_lgl(default = TRUE),
        getImp = p_uty(),
        keep = p_fct(levels = c("confirmed", "tentative"), default = "confirmed")
      )

      param_set$set_values(keep = "confirmed")

      super$initialize(
        id = "boruta",
        task_types = c("regr", "classif"),
        param_set = param_set,
        packages = "Boruta",
        feature_types = c("integer", "numeric"),
        label = "Burota",
        man = "mlr3filters::mlr_filters_boruta"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values
      data = task$data()
      target = task$target_names
      features = task$feature_names
      formula = formulate(target, features)
      keep = pv$keep
      pv$keep = NULL

      res = invoke(Boruta::Boruta, formula = formula, data = data, .args = pv)

      selected_features = Boruta::getSelectedAttributes(res, withTentative = (keep == "tentative"))

      set_names(as.numeric(features %in% selected_features), features)
    }
  )
)


#' @include mlr_filters.R
mlr_filters$add("boruta", FilterBoruta)
