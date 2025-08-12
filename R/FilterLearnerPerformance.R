#' @include Filter.R
FilterLearnerPerformance = R6Class("FilterLearnerPerformance", inherit = Filter,
  public = list(
    initialize = function(learner, resampling, measure, dict_entry, additional_param_set = ps()) {
      private$.learner = learner
      private$.resampling = resampling
      private$.measure = measure
      private$.additional_param_set = assert_param_set(additional_param_set)
      super$initialize(
        id = learner$id,
        dict_entry = dict_entry,
        task_types = learner$task_type,
        feature_types = learner$feature_types,
        packages = c(learner$packages, resampling$packages, measure$packages),
        properties = intersect("missings", learner$properties),
        param_set = alist(
          lrn = private$.learner$param_set, rsmp = private$.resampling$param_set,
          msr = private$.measure$param_set,
          private$.additional_param_set
        )
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
    },
    #' @field resampling ([mlr3::Resampling])\cr
    #'   Resampling to be used for performance evaluation.
    resampling = function(rhs) {
      if (!missing(rhs) && !identical(rhs, private$.resampling)) {
        stop("Cannot modify read-only field 'resampling'")
      }
      private$.resampling
    },
    #' @field measure ([mlr3::Measure])\cr
    #'   Measure to be used for performance evaluation.
    measure = function(rhs) {
      if (!missing(rhs) && !identical(rhs, private$.measure)) {
        stop("Cannot modify read-only field 'measure'")
      }
      private$.measure
    }
  ),
  private = list(
    .learner = NULL,
    .resampling = NULL,
    .measure = NULL,
    .additional_param_set = NULL,
    .additional_phash_input = function() c(private$.learner$phash, private$.resampling$phash, private$.measure$phash)
  )
)
