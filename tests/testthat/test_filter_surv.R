skip_if_not_installed("mlr3proba")

test_that("mlr3proba learners work", {
  requireNamespace("mlr3proba")
  task = tsk("rats")
  learner = lrn("surv.coxph")
  resampling = rsmp("holdout")

  f = flt("performance", learner = learner, resampling = resampling)
  f$calculate(task)

  expect_filter(f, task = task)
})
