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

test_that("filters throw errors on missing values", {
  data = tsk("mtcars")$data()
  data$cyl[1] = NA
  task = as_task_regr(data, target = "mpg")

  filters = mlr_filters$mget(mlr_filters$keys())

  for (f in filters) {
    if (!is_scalar_na(f$task_types)) {
      next
    }

    if (!all(require_namespaces(f$packages, quietly = TRUE))) {
      next
    }

    if ("missings" %in% f$properties) {
      f$calculate(task)
    } else {
      expect_error(f$calculate(task), "missing values")
    }
  }
})
