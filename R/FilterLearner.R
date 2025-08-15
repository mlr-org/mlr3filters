#' @include Filter.R
FilterLearner = R6Class("FilterLearner", inherit = Filter,
  public = list(
    initialize = function(learner, dict_entry) {
      private$.learner = learner
      super$initialize(
        id = paste0(dict_entry, ".", learner$id),
        dict_entry = dict_entry,
        task_types = learner$task_type,
        feature_types = learner$feature_types,
        packages = learner$packages,
        properties = intersect("missings", learner$properties),
        param_set = alist(private$.learner$param_set)
      )
    }
  ),
  active = list(
    #' @field learner ([mlr3::Learner])\cr
    #'   Learner to extract the importance values from.
    learner = function(rhs) {
      if (!missing(rhs) && !identical(rhs, private$.learner)) {
        stop("Cannot modify read-only field 'learner'")
      }
      private$.learner
    }
  ),
  private = list(
    .learner = NULL,
    .additional_phash_input = function() private$.learner$phash
  )
)
