library(checkmate)
library(mlr3)
lapply(list.files(system.file("testthat", package = "mlr3"), pattern = "^helper.*\\.[rR]", full.names = TRUE), source)

expect_filter_result = function(f, task = NULL) {

  expect_r6(f, "Filter",
    public = c("packages", "feature_types", "task_type", "param_set", "scores"),
    private = c(".calculate")
  )

  expect_character(f$packages, any.missing = FALSE, unique = TRUE)
  expect_subset(f$task_type, mlr_reflections$task_types)
  expect_subset(f$feature_types, mlr_reflections$task_feature_types)
  expect_class(f$param_set, "ParamSet")
  expect_function(private(f)$.calculate, args = "task")

  if (!is.null(f$scores)) {
    expect_data_table(f$scores)
    checkSubset(colnames(f$scores), c("method", "scores"))
  }

  if (!is.null(task)) {
    x = f$clone(deep = TRUE)$calculate(task)
    expect_class(x, "Filter")
    # FIXME
    # expect_data_table(f$scores)
    # FIXME
    # expect_names(names(x$scores), permutation.of = task$feature_names)
  }
}

create_filters_custom = function(task_type, param_vals = NULL) {
  filter_all = mlr_filters$mget(mlr_filters$keys()[!mlr_filters$keys() %in% c("variance",
    "information_gain", "gain_ratio", "symmetrical_uncertainty")],
    param_vals = param_vals)
  # we need to merge FilterVariance manually as its required argument 'na.rm' would conflict during batch creation
  filter_var = mlr_filters$get("variance", param_vals = c(param_vals, na.rm = TRUE))
  filter_entropy = mlr_filters$mget(c("information_gain", "gain_ratio",
    "symmetrical_uncertainty"), param_vals = c(param_vals, equal= TRUE))

  filter_all = c(filter_all, filter_var, filter_entropy)

  filter_all_regr = map_lgl(filter_all, function(x) task_type %in% x$task_type)
  # subset to "regr" filters only
  filter_all_regr = filter_all[filter_all_regr]

  return(filter_all_regr)
}

task = mlr3::mlr_tasks$get("mtcars")
task_bh = mlr3::mlr_tasks$get("boston_housing")
