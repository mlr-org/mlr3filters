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
  public = list(
    #' @field id (`character(1)`)\cr
    #'   Identifier of the object.
    #'   Used in tables, plot and text output.
    id = NULL,

    #' @field label (`character(1)`)\cr
    #'   Label for this object.
    #'   Can be used in tables, plot and text output instead of the ID.
    label = NA_character_,

    #' @field task_types (`character()`)\cr
    #'   Set of supported task types, e.g. `"classif"` or `"regr"`.
    #'   Can be set to the scalar value `NA` to allow any task type.
    #'
    #'   For a complete list of possible task types (depending on the loaded packages),
    #'   see [`mlr_reflections$task_types$type`][mlr_reflections].
    task_types = NULL,

    #' @field task_properties (`character()`)\cr
    #'   [mlr3::Task]task properties.
    task_properties = NULL,

    #' @field param_set ([paradox::ParamSet])\cr
    #'   Set of hyperparameters.
    param_set = NULL,

    #' @field feature_types (`character()`)\cr
    #'   Feature types of the filter.
    feature_types = NULL,

    #' @field packages ([character()])\cr
    #'   Packages which this filter is relying on.
    packages = NULL,

    #' @field man (`character(1)`)\cr
    #'   String in the format `[pkg]::[topic]` pointing to a manual page for this object.
    #'   Defaults to `NA`, but can be set by child classes.
    man = NULL,

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
    initialize = function(id, task_types, task_properties = character(),
      param_set = ps(), feature_types = character(), packages = character(), label = NA_character_,
      man = NA_character_) {

      self$id = assert_string(id)
      self$label = assert_string(label, na.ok = TRUE)
      if (!test_scalar_na(task_types)) {
        # we allow any task type here, otherwise we are not able to construct
        # the filter without loading additional packages like mlr3proba
        assert_character(task_types, any.missing = FALSE)
      }
      self$task_types = task_types
      self$task_properties = assert_subset(task_properties, unlist(mlr_reflections$task_properties, use.names = FALSE))
      self$param_set = assert_param_set(param_set)
      self$feature_types = assert_subset(feature_types, mlr_reflections$task_feature_types)
      self$packages = assert_character(packages, any.missing = FALSE, min.chars = 1L)
      self$scores = set_names(numeric(), character())
      self$man = assert_string(man, na.ok = TRUE)
    },

    #' @description
    #' Format helper for Filter class
    #' @param ... (ignored).
    format = function(...) {
      sprintf("<%s:%s>", class(self)[1L], self$id) # nocov
    },

    #' @description
    #' Printer for Filter class
    print = function() {
      msg_h = if (is.na(self$label)) "" else paste0(": ", self$label)
      cli_h1("{.cls {class(self)[1L]}} {self$id}{msg_h}")
      cli_li("Task Types: {self$task_types}")
      properties = if (length(self$properties)) paste(self$properties, collapse = ", ") else "-"
      cli_li("Properties: {properties}")
      cli_li("Task Properties: {self$task_properties}")
      cli_li("Packages: {.pkg {self$packages}}")
      cli_li("Feature types: {self$feature_types}")
      if (length(self$scores)) {
        print(as.data.table(self),
              nrows = 10L, topn = 5L, class = FALSE,
              row.names = TRUE, print.keys = FALSE)
      }
    },

    #' @description
    #' Opens the corresponding help page referenced by field `$man`.
    help = function() {
      open_help(self$man) # nocov
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
  ),

  active = list(
    #' @field properties ([character()])\cr
    #'   Properties of the filter. Currently, only `"missings"` is supported.
    #'   A filter has the property `"missings"`, iff the filter can handle missing values
    #'   in the features in a graceful way. Otherwise, an assertion is thrown if missing
    #'   values are detected.
    properties = function(rhs) {
      assert_ro_binding(rhs)
      get_properties = get0(".get_properties", private)
      if (is.null(get_properties)) character() else get_properties()
    },

    #' @field hash (`character(1)`)\cr
    #' Hash (unique identifier) for this object.
    hash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$param_set$values, mget(private$.extra_hash, envir = self))
    },

    #' @field phash (`character(1)`)\cr
    #' Hash (unique identifier) for this partial object, excluding some components
    #' which are varied systematically during tuning (parameter values) or feature
    #' selection (feature names).
    phash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, mget(private$.extra_hash, envir = self))
    }
  ),

  private = list(
    .extra_hash = character()
  )
)

#' @export
as.data.table.Filter = function(x, ...) { # nolint
  mlr3misc::enframe(x$scores, name = "feature", value = "score")
}
