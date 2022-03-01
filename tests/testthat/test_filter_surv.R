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
