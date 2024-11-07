skip_if_not_installed("mlr3proba")

test_that("mlr3proba learners work", {
  requireNamespace("mlr3proba")

  # needs to be fixed in mlr3proba
  withr::local_options(warnPartialMatchDollar = FALSE, warnPartialMatchArgs = FALSE, warnPartialMatchAttr = FALSE)

  task = tsk("rats")
  learner = lrn("surv.rpart")
  resampling = rsmp("holdout")

  f = flt("performance", learner = learner, resampling = resampling)
  f$calculate(task)

  expect_filter(f, task = task)
})

test_that("filters throw errors on missing values", {
  task = tsk("rats")$select(c("litter", "rx"))
  data = task$data()
  data$litter[1] = NA
  task = mlr3proba::as_task_surv(data, target = "time", event = "status")

  filters = mlr_filters$mget(mlr_filters$keys())

  for (f in filters) {
    if ("surv" %nin% f$task_types) {
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


