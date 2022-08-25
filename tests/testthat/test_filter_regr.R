test_that("all regr filters return correct filter values", {
  task = mlr_tasks$get("mtcars")
  filters = mlr_filters$mget(mlr_filters$keys())

  for (f in filters) {
    if ("regr" %in% f$task_type && all(require_namespaces(f$packages, quietly = TRUE))) {
      f$calculate(task)
      expect_filter(f, task = task)
    }
  }
})


test_that("Errors for unsupported features", {
  filters = mlr_filters$mget(mlr_filters$keys())

  # supported: numeric, integer
  # supplied: factor, integer, numeric
  for (f in filters) {
    if (any(c("integer", "numeric") %in% f$feature_types) && all(require_namespaces(f$packages, quietly = TRUE))) {
      expect_error(f$calculate(task_bh))
    }
  }
})
