#' @title FeatureSelectionForward
#'
#' @description
#' FeatureSelection child class to conduct forward search.
#'
#' @section Usage:
#'  ```
#' fs = FeatureSelectionForward$new()
#' ```
#' See [FeatureSelection] for a description of the interface.
#'
#' @section Arguments:
#' * `pe` (`[PerformanceEvaluator]`).
#' * `tm` (`[Terminator]`).
#' * `max_features` (`integer(1)`)
#'   Maximum number of features
#'
#' @section Details:
#' `$new()` creates a new object of class [FeatureSelectionForward].
#' `$get_result()` Returns selected features in each step.
#' The interface is described in [FeatureSelection].
#'
#' Each step is possibly executed in parallel via [mlr3::benchmark()]
#'
#' @name FeatureSelectionForward
#' @family FeatureSelection
NULL

#' @export
#' @include FeatureSelection.R

FeatureSelectionForward = R6Class("FeatureSelectionRandom",
   inherit = FeatureSelection,
   public = list(
      initialize = function(pe, tm, max_features = NA) {
         super$initialize(id = "forward_selection", pe = pe, tm = tm,
                           settings = list(max_features = checkmate::assert_numeric(max_features,
                                                                                    lower = 1,
                                                                                    upper = length(pe$task$feature_names))))

         self$state = rep(0, length(pe$task$feature_names))
     },

     get_result = function() {
        bmr = lapply(self$pe$bmr, function(bmr) bmr$get_best(self$pe$task$measures[[1L]]$id))
        lapply(bmr, function(x) x$task$feature_names)
     },
     get_optimization_path = function() {
        mapply(function(bmr, states) {
           performance = as.data.table(bmr$aggregated())[,self$pe$task$measures[[1]]$id, with=FALSE]
           features = t(as.data.table(states))
           data.table::setorderv(cbind(performance, features), self$pe$task$measures[[1]]$id, order=-1)

        }, bmr=self$pe$bmr, states=self$pe$states)
     }
   ),
   private = list(
      generate_states = function() {
         new_states = list()
         for (i in seq_along(self$state)) {
            if (self$state[i] == 0) {
            state = self$state
            state[i] = 1
            new_states[[length(new_states) + 1]] = state
            }
         }
         new_states
      }
   )
)
