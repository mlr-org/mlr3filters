#' @include Filter.R
FilterLearner = R6Class("FilterLearner", inherit = Filter,
  active = list(
    #' @field hash (`character(1)`)\cr
    #' Hash (unique identifier) for this object.
    hash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$param_set$values, self$learner$hash)
    },

    #' @field phash (`character(1)`)\cr
    #' Hash (unique identifier) for this partial object, excluding some components
    #' which are varied systematically during tuning (parameter values) or feature
    #' selection (feature names).
    phash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$learner$hash)
    }
  )
)
