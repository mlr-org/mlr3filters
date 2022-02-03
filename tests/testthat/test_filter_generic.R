test_that("all generic filters return correct filter values", {
  task = mlr_tasks$get("mtcars")
  filters = mlr_filters$mget(as.data.table(mlr_filters)[map_lgl(task_type,
    is.element,
    el = NA), key])

  for (f in filters) {
    expect_filter(f)
    f$calculate(task)
    expect_filter(f, task = task)
  }
})
