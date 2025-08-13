#' @title Filter Base Class
#'
#' @description Base class for filters. Predefined filters are stored in the
#' [dictionary][mlr3misc::Dictionary] [mlr_filters]. A Filter calculates a score
#' for each feature of a task. Important features get a large value and
#' unimportant features get a small value. Note that filter scores may also be
#' negative.
#'
#' @details
#' Some features support partial scoring of the feature set:
#' If `nfeat` is not `NULL`, only the best `nfeat` features are guaranteed to
#' get a score. Additional features may be ignored for computational reasons,
#' and then get a score value of `NA`.
#'
#' @importFrom stats runif
#' @family Filter
#' @export
Filter = R6Class("Filter",
  inherit = Mlr3Component,
  public = list(
    #' @field task_types (`character()`)\cr
    #'   Set of supported task types, e.g. `"classif"` or `"regr"`.
    #'   Can be set to the scalar value `NA` to allow any task type.
    #'
    #'   For a complete list of possible task types (depending on the loaded packages),
    #'   see [`mlr_reflections$task_types$type`][mlr3::mlr_reflections].
    task_types = NULL,

    #' @field task_properties (`character()`)\cr
    #'   [mlr3::Task]task properties.
    task_properties = NULL,

    #' @field feature_types (`character()`)\cr
    #'   Feature types of the filter.
    feature_types = NULL,

    #' @field scores
    #'   Stores the calculated filter score values as named numeric vector.
    #'   The vector is sorted in decreasing order with possible `NA` values
    #'   last. The more important the feature, the higher the score.
    #'   Tied values (this includes `NA` values) appear in a random,
    #'   non-deterministic order.
    scores = NULL,

    #' @description Create a Filter object.
    #' @param id (`character(1)`)\cr
    #'   Identifier for the filter.
    #' @param task_types (`character()`)\cr
    #'   Types of the task the filter can operator on. E.g., `"classif"` or
    #'   `"regr"`. Can be set to scalar `NA` to allow any task type.
    #' @param param_set ([paradox::ParamSet])\cr
    #'   Set of hyperparameters.
    #' @param feature_types (`character()`)\cr
    #'   Feature types the filter operates on.
    #'   Must be a subset of
    #'   [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
    #' @param task_properties (`character()`)\cr
    #'   Required task properties, see [mlr3::Task].
    #'   Must be a subset of
    #'   [`mlr_reflections$task_properties`][mlr3::mlr_reflections].
    #' @param packages (`character()`)\cr
    #'   Set of required packages.
    #'   Note that these packages will be loaded via [requireNamespace()], and
    #'   are not attached.
    #' @param label (`character(1)`)\cr
    #'   Label for the new instance.
    #' @param man (`character(1)`)\cr
    #'   String in the format `[pkg]::[topic]` pointing to a manual page for
    #'   this object. The referenced help package can be opened via method
    #'   `$help()`.
    initialize = function(dict_entry, task_types, task_properties = character(0),
      param_set = ps(), feature_types = character(0), packages = character(0),
      properties = character(0), label, man, id = dict_entry
    ) {
      if (!missing(label) || !missing(man)) {
        deprecated_component("label and man are deprecated for Filter construction and will be removed in the future.")
      }

      super$initialize(dict_entry = dict_entry, dict_shortaccess = "flt", id = id,
        param_set = param_set, packages = packages, properties = properties)

      if (!test_scalar_na(task_types)) {
        # we allow any task type here, otherwise we are not able to construct
        # the filter without loading additional packages like mlr3proba
        assert_character(task_types, any.missing = FALSE)
      }
      assert_subset(properties, mlr_reflections$filter_properties)  # only allow missings for now
      self$task_types = task_types
      self$task_properties = assert_subset(task_properties, unlist(mlr_reflections$task_properties, use.names = FALSE))
      self$feature_types = assert_subset(feature_types, mlr_reflections$task_feature_types)
      self$scores = set_names(numeric(), character())
    },

    #' @description
    #' Printer for Filter class
    print = function() {
      catn(format(self), if (is.na(self$label)) "" else paste0(": ", self$label))
      catn(str_indent("Task Types:", self$task_types))
      catn(str_indent("Properties:", self$properties))
      catn(str_indent("Task Properties:", self$task_properties))
      catn(str_indent("Packages:", self$packages))
      catn(str_indent("Feature types:", self$feature_types))
      if (length(self$scores)) {
        print(as.data.table(self),
          nrows = 10L, topn = 5L, class = FALSE,
          row.names = TRUE, print.keys = FALSE)
      }
    },

    #' @description
    #'   Calculates the filter score values for the provided [mlr3::Task] and
    #'   stores them in field `scores`. `nfeat` determines the minimum number of
    #'   features to score (see details), and defaults to the number
    #'   of features in `task`. Loads required packages and then calls
    #'   `private$.calculate()` of the respective subclass.
    #'
    #'   This private method is is expected to return a numeric vector, uniquely named
    #'   with (a subset of) feature names. The returned vector may have missing
    #'   values.
    #'   Features with missing values as well as features with no calculated
    #'   score are automatically ranked last, in a random order.
    #'   If the task has no rows, each feature gets the score `NA`.
    #' @param task ([mlr3::Task])\cr
    #'   [mlr3::Task] to calculate the filter scores for.
    #' @param nfeat ([integer()])\cr
    #'   The minimum number of features to calculate filter scores for.
    calculate = function(task, nfeat = NULL) {
      task = assert_task(as_task(task),
        feature_types = self$feature_types,
        task_properties = self$task_properties
      )

      fn = task$feature_names

      if (!is_scalar_na(self$task_types) && !some(self$task_types, test_matching_task_type, object = task, class = "learner")) {
        stopf("Filter '%s' not compatible with type '%s' of task '%s'",
          self$id, task$task_type, task$id)
      }

      if (task$nrow == 0L) {
        self$scores = shuffle(set_names(rep.int(NA_real_, length(fn)), fn))
      } else if (length(fn) == 0L) {
        self$scores = set_names(numeric(), character())
      } else {
        if (is.null(nfeat)) {
          nfeat = length(fn)
        } else {
          nfeat = assert_count(nfeat, coerce = TRUE)
          nfeat = min(nfeat, length(fn))
        }

        if ("missings" %nin% self$properties && any(task$missings() > 0L)) {
          stopf("Cannot apply filter '%s' on task '%s', missing values detected",
            self$id, task$id)
        }

        # calculate filter values using the dedicated filter
        require_namespaces(self$packages)
        scores = private$.calculate(task, nfeat)

        # check result, re-order with correction for ties
        assert_numeric(scores, any.missing = TRUE, names = "unique")
        assert_names(names(scores), type = "unique", subset.of = fn)
        scores = insert_named(set_names(rep(NA_real_, length(fn)), fn), scores)
        self$scores = scores[order(scores, runif(length(scores)),
          decreasing = TRUE, na.last = TRUE)]
      }

      invisible(self)
    }
  )
)

#' @export
as.data.table.Filter = function(x, ...) { # nolint
  mlr3misc::enframe(x$scores, name = "feature", value = "score")
}
