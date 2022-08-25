test_that("all classif filters return correct filter values", {
  task = mlr_tasks$get("sonar")
  task$select(head(task$feature_names, 10))
  filters = mlr_filters$mget(mlr_filters$keys())
  filters$permutation$param_set$values = list(nmc = 2)

  for (f in filters) {
    if ("classif" %in% f$task_type && all(require_namespaces(f$packages, quietly = TRUE))) {
      f$calculate(task)
      expect_filter(f, task = task)
    }
  }
})
