#' @title Filter Base Class
#'
#' @description Base class for filters. Predefined filters are stored in the
#' [dictionary][mlr3misc::Dictionary] [mlr_filters]. A Filter calculates a score
#' for each feature of a task. Important features get a large value and
#' unimportant features get a small value. Note that filter scores may also be
#' negative.
#'
#' @template field_id
#' @template field_task_type
#' @template field_task_properties
#' @template field_param_set
#' @template field_feature_types
#' @template field_packages
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
    id = NULL,
    task_type = NULL,
    task_properties = NULL,
    param_set = NULL,
    feature_types = NULL,
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
    #' @param task_type (`character()`)\cr
    #'   Types of the task the filter can operator on. E.g., `"classif"` or
    #'   `"regr"`.
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
    #' @param man (`character(1)`)\cr
    #'   String in the format `[pkg]::[topic]` pointing to a manual page for
    #'   this object. The referenced help package can be opened via method
    #'   `$help()`.
    initialize = function(id, task_type, task_properties = character(),
      param_set = ParamSet$new(), feature_types = character(),
      packages = character(), man = NA_character_) {

      self$id = assert_string(id)
      self$task_type = assert_subset(task_type, mlr_reflections$task_types$type,
        empty.ok = FALSE)
      self$task_properties = assert_subset(
        task_properties,
        unlist(mlr_reflections$task_properties, use.names = FALSE))
      self$param_set = assert_param_set(param_set)
      self$feature_types = assert_subset(
        feature_types,
        mlr_reflections$task_feature_types)
      self$packages = assert_character(packages,
        any.missing = FALSE,
        unique = TRUE)
      self$scores = set_names(numeric(), character())
      self$man = assert_string(man, na.ok = TRUE)
    },

    #' @description
    #' Format helper for Filter class
    format = function() {
      sprintf("<%s:%s>", class(self)[1L], self$id) # nocov
    },

    #' @description
    #' Printer for Filter class
    print = function() {
      catf(format(self)) # nocov start
      catf(str_indent("Task Types:", self$task_type))
      catf(str_indent("Task Properties:", self$task_properties))
      catf(str_indent("Packages:", self$packages))
      catf(str_indent("Feature types:", self$feature_types))
      if (length(self$scores)) {
        print(as.data.table(self),
          nrows = 10L, topn = 5L, class = FALSE,
          row.names = TRUE, print.keys = FALSE) # nocov end
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
    #'   This private method is is expected to return a numeric vector, uniquely named
    #'   with (a subset of) feature names. The returned vector may include missing
    #'   values. Features with missing values and features with no calculated score are
    #'   ranked last, in a random order.
    #'
    #'   If the task has no rows, each feature gets the score `NA`.
    #' @param task ([mlr3::Task])\cr
    #'   [mlr3::Task] to calculate the filter scores for.
    #' @param nfeat ([integer()])\cr
    #'   The minimum number of features to calculate filter scores for.
    calculate = function(task, nfeat = NULL) {
      task = assert_task(as_task(task),
        feature_types = self$feature_types,
        task_properties = self$task_properties)
      fn = task$feature_names

      if (task$nrow == 0L) {
        self$scores = shuffle(set_names(rep.int(NA_real_, length(fn)), fn))
      } else if (length(fn) == 0L) {
        self$scores = set_names(numeric(), character())
      } else {
        if (is.null(nfeat)) {
          nfeat = length(fn)
        } else {
          nfeat = assert_count(nfeat, coerce = TRUE)
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
