test_that("all regr filters return correct filter values", {
  task = mlr_tasks$get("mtcars")
  filters = mlr_filters$mget(as.data.table(mlr_filters)[map_lgl(task_type,
    is.element,
    el = "regr"), key])

  for (f in filters) {
    if (!all(require_namespaces(f$packages, quietly = TRUE))) {
      next
    }
    f$calculate(task)
    expect_filter(f, task = task)
  }
})


test_that("Errors for unsupported features", {
  # list filters that only support "numeric" features
  filters = mlr_filters$mget(mlr_filters$keys())
  filters = Filter(function(x) {
    all(grepl(paste(c("numeric", "integer"),
      collapse = "|"), x$feature_types))
  }, filters)
  filters = filters[lengths(filters) != 0]

  # supported: numeric, integer
  # supplied: factor, integer, numeric
  for (f in filters) {
    if (!all(require_namespaces(f$packages, quietly = TRUE))) {
      next
    }
    expect_error(f$calculate(task_bh))
  }
})
