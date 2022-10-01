test_that("all classif filters return correct filter values", {
  task = mlr_tasks$get("sonar")
  task$select(head(task$feature_names, 10))
  filters = mlr_filters$mget(mlr_filters$keys())
  filters$permutation$param_set$values = list(nmc = 2)

  for (f in filters) {
    if ("classif" %in% f$task_types && all(require_namespaces(f$packages, quietly = TRUE))) {
      f$calculate(task)
      expect_filter(f, task = task)
    }
  }
})


test_that("filters throw errors on missing values", {
  data = tsk("sonar")$data()
  data$V1[1] = NA
  task = as_task_classif(data, target = "Class")

  filters = mlr_filters$mget(mlr_filters$keys())

  for (f in filters) {
    if ("classif" %in% f$task_types && all(require_namespaces(f$packages, quietly = TRUE))) {
      expect_error(f$calculate(task), "missing values")
    }
  }
})
