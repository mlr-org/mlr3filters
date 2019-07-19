#' @title Filter Base Class
#'
#' @usage NULL
#' @format [R6::R6Class] object.
#'
#' @description Base class for filters. Predefined filters are stored in
#'   [mlr_filters]. Filters calculate a score for each feature of a dataset and
#'   return a ranked scoring.
#'
#' @section Construction:
#'
#'   ```
#'   f = Filter$new(id, task_type, param_set, param_vals, feature_types, packages)
#'   ```
#'
#'   * `id` :: `character(1)`\cr Identifier for the filter.
#'
#'   * `task_type` :: `character(1)`\cr Type of the task the filter can operator
#'   on. E.g., `"classif"` or `"regr"`.
#'
#'   * `param_set` :: [paradox::ParamSet]\cr Set of hyperparameters.
#'
#'   * `param_vals` :: named `list()`\cr Named list of hyperparameter settings.
#'
#'   * `feature_types` :: `character()`\cr Feature types the filter operates on.
#'   Must be a subset of
#'   [`mlr_reflections$task_feature_types`][mlr3::mlr_reflections].
#'
#'   * `task_properties` :: `character()`\cr Required task properties, see
#'   [mlr3::Task]. Must be a subset of
#'   [`mlr_reflections$task_properties`][mlr3::mlr_reflections].
#'
#'   * `packages` :: `character()`\cr Set of required packages. Note that these
#'   packages will be loaded via [requireNamespace()], and are not attached.
#'
#' @section Fields:
#'
#'   All fields from the Constructor and
#'
#'   * `scores` :: [data.table::data.table]\cr Stores the calculated filter
#'   score values. The scores are sorted in decreasing order, with tied values
#'   in a random order.
#'
#' @section Methods:
#'
#'   * `calculate(task, nfeat = NULL)`\cr ([Task], `numeric(1)`) -> [Filter]\cr
#'   Calculates the filter score values for the provided [Task] and stores them
#'   in field `scores`. Some filter support partial scoring via argument `n`.
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

    initialize = function(id, task_type, task_properties = character(),
      param_set = list(), param_vals = list(), feature_types = character(),
      packages = character()) {

      # add generic hyperpars to param_set of filter
      param_set$add(ParamSet$new(list(
          ParamDbl$new("nfeat", lower = 0, default = 1),
          ParamFct$new("type", levels = c("abs", "frac", "cutoff"), default = "frac")
      )))

      self$id = assert_string(id)
      self$task_type = assert_subset(task_type, mlr_reflections$task_types, empty.ok = FALSE)
      self$task_properties = assert_subset(task_properties, unlist(mlr_reflections$task_properties, use.names = FALSE))
      self$param_set = assert_param_set(param_set)
      self$param_set$values = insert_named(self$param_set$values, param_vals)
      self$feature_types = assert_subset(feature_types, mlr_reflections$task_feature_types)
      self$packages = assert_character(packages, any.missing = FALSE, unique = TRUE)
    },

    format = function() {
      sprintf("<%s:%s>", class(self)[1L], self$id)
    },

    print = function() {
      filter_print(self)
    },

    calculate = function(task, nfeat) {

      assert_task(task, feature_types = self$feature_types,
        task_properties = self$task_properties)
      assert_filter_result(self, task)
      require_namespaces(self$packages)
      fn = task$feature_names

      # check if n was given by the user or not
      if (!is.null(self$param_set$get_values()$nfeat)) {
        nfeat = self$param_set$get_values()$nfeat
      } else {
        nfeat = self$param_set$default$nfeat
      }
      # check if type was given by the user or not
      if (!is.null(self$param_set$get_values()$type)) {
        type = self$param_set$get_values()$type
      } else {
        type = self$param_set$default$type
      }

      # adjust n according to arg 'type'
      if (type == "frac") {
        assert_numeric(nfeat, lower = 0, upper = 1)
        nfeat = length(fn) * nfeat
      } else if (type == "cutoff") {
        nfeat = names(scores > cutoff)
      } else {
        assert_count(nfeat)
      }

      # calculate filter values using the dedicated filter
      fv = private$.calculate(task, nfeat)

      self$scores = data.table(score = fv, feature = names(fv))[order(-score)]

      # subset result to given 'n'
      # this is done to stay consistent with partial scoring filter which only
      # return partial values
      self$scores = self$scores[1:nfeat, ]

      assert_numeric(self$scores$score, len = nfeat, any.missing = FALSE)

      invisible(self)
    },

    get_best = function(nfeat, type = "abs") {

      if (type == "frac") {
        assert_numeric(nfeat, lower = 0, upper = 1)
        nfeat = length(fn) * nfeat
      } else if (type == "cutoff") {
        nfeat = names(scores > cutoff)
      } else {
        assert_count(nfeat)
      }

      if (is.null(self$scores)) {
        stopf("Filter values have not been calculated yet.")
      }

      if (nfeat > nrow(self$scores)) {
        warningf("'n' exceeds the number of stored filter values. Returning all feature names.")
        nfeat = nrow(self$scores)
      }

      # return best n features
      keep = head(self$scores$feature, nfeat)
      return(keep)
    }
  )
)

#' @export
as.data.table.Filter = function(x, ...) {
  fv = x$scores
  if (is.null(fv)) {
    stopf("No filter data available")
  }
  return(fv)
}

filter_print = function(self) {
  catf(format(self))
  catf(str_indent("Task Types:", self$task_type))
  catf(str_indent("Task Properties:", self$task_properties))
  catf(str_indent("Packages:", self$packages))
  catf(str_indent("Feature types:", self$feature_types))
}
