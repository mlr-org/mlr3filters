#' @title Filter Base Class
#'
#' @usage NULL
#' @format [R6::R6Class] object.
#'
#' @description
#' Base class for filters. Predefined filters are stored in the [dictionary][mlr3misc::Dictionary] [mlr_filters].
#' A Filter calculates a score for each feature of a task.
#' Important features get a large value and unimportant features get a small value.
#' Note that filter scores may also be negative.
#'
#' @section Construction:
#'
#'   ```
#'   f = Filter$new(id, task_type, param_set, param_vals, feature_types, packages)
#'   ```
#'
#'   * `id` :: `character(1)`\cr
#'     Identifier for the filter.
#'
#'   * `task_type` :: `character()`\cr
#'     Types of the task the filter can operator on. E.g., `"classif"` or `"regr"`.
#'
#'   * `param_set` :: [paradox::ParamSet]\cr
#'     Set of hyperparameters.
#'
#'   * `param_vals` :: named `list()`\cr
#'     Named list of hyperparameter settings.
#'
#'   * `feature_types` :: `character()`\cr
#'     Feature types the filter operates on.
#'     Must be a subset of [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
#'
#'   * `task_properties` :: `character()`\cr
#'     Required task properties, see [mlr3::Task].
#'     Must be a subset of [`mlr_reflections$task_properties`][mlr3::mlr_reflections].
#'
#'   * `packages` :: `character()`\cr
#'     Set of required packages.
#'     Note that these packages will be loaded via [requireNamespace()], and are not attached.
#'
#' @section Fields:
#'
#'   All arguments passed to the constructor are available as fields, and additionally:
#'
#'   * `scores` :: named `numeric()`\cr
#'   Stores the calculated filter score values as named numeric vector.
#'   The vector is sorted in decreasing order with possible `NA` values last.
#'   Tied values (this includes `NA` values) appear in a random, non-deterministic order.
#'
#' @section Methods:
#'
#'   * `calculate(task, nfeat = NULL)`\cr
#'     ([mlr3::Task], `integer(1)`) -> `self`\cr
#'     Calculates the filter score values for the provided [mlr3::Task] and stores them in field `scores`.
#'     `nfeat` determines the minimum number of features to score (see "Partial Scoring"), and defaults to the number of features in `task`.
#'     Loads required packages and then calls `$calculate_internal()`.
#'
#'   * `calculate_internal(task, nfeat)`\cr
#'     ([mlr3::Task], `integer(1)`) -> named `numeric()`\cr
#'     Internal worker function. Each child class muss implement this method.
#'     Takes a task and the minimum number of features to score, and must return a named numeric with scores.
#'     The higher the score, the more important the feature.
#'     The calling function (`calculate()`) ensures that the returned vector gets sorted and that missing feature scores get a score value of `NA`.
#'
#' @section Partial Scoring:
#' Some features support partial scoring of the feature set:
#' If `nfeat` is not `NULL`, only the best `nfeat` features are guaranteed to get a score.
#' Additional features may be ignored for computational reasons, and then get a score value of `NA`.
#'
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
    scores = NULL,

    initialize = function(id, task_type, task_properties = character(), param_set = ParamSet$new(), param_vals = list(),
      feature_types = character(), packages = character()) {

      self$id = assert_string(id)
      self$task_type = assert_subset(task_type, mlr_reflections$task_types, empty.ok = FALSE)
      self$task_properties = assert_subset(task_properties, unlist(mlr_reflections$task_properties, use.names = FALSE))
      self$param_set = assert_param_set(param_set)
      self$param_set$values = insert_named(self$param_set$values, param_vals)
      self$feature_types = assert_subset(feature_types, mlr_reflections$task_feature_types)
      self$packages = assert_character(packages, any.missing = FALSE, unique = TRUE)
      self$scores = set_names(numeric(), character())
    },

    format = function() {
      sprintf("<%s:%s>", class(self)[1L], self$id)
    },

    print = function() {
      catf(format(self))
      catf(str_indent("Task Types:", self$task_type))
      catf(str_indent("Task Properties:", self$task_properties))
      catf(str_indent("Packages:", self$packages))
      catf(str_indent("Feature types:", self$feature_types))
    },

    calculate = function(task, nfeat = NULL) {

      task = assert_task(task, feature_types = self$feature_types, task_properties = self$task_properties)
      fn = task$feature_names
      if (is.null(nfeat)) {
        nfeat = length(fn)
      } else {
        nfeat = assert_count(nfeat, coerce = TRUE)
      }

      # calculate filter values using the dedicated filter
      require_namespaces(self$packages)
      scores = self$calculate_internal(task, nfeat)

      # check result, re-order with correction for ties
      assert_numeric(scores, any.missing = FALSE, names = "unique")
      assert_names(names(scores), subset.of = fn)
      scores = insert_named(set_names(rep(NA_real_, length(fn)), fn), scores)
      self$scores = scores[order(scores, runif(length(scores)), decreasing = TRUE, na.last = TRUE)]

      invisible(self)
    }
  )
)

#' @export
as.data.table.Filter = function(x, ...) {
  enframe(x$scores, name = "feature", value = "score")
}
