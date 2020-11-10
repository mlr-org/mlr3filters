test_that("all classif filters return correct filter values", {
  task = mlr_tasks$get("sonar")
  task$select(head(task$feature_names, 10))
  filters = mlr_filters$mget(as.data.table(mlr_filters)[map_lgl(task_type,
    is.element,
    el = "classif"), key])
  filters$permutation$param_set$values = list(nmc = 2)

  for (f in filters) {
    expect_filter(f)
    f$calculate(task)
    expect_filter(f, task = task)
  }
})
