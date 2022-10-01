test_that("all generic filters return correct filter values", {
  task = mlr_tasks$get("mtcars")
  filters = mlr_filters$mget(mlr_filters$keys())

  for (f in filters) {
    if (NA %in% f$task_types && all(require_namespaces(f$packages, quietly = TRUE))) {
      f$calculate(task)
      expect_filter(f, task = task)
    }
  }
})
