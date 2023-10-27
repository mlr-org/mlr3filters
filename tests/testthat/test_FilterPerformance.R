test_that("FilterPerformance", {
  task = mlr3::mlr_tasks$get("iris")
  learner = mlr3::mlr_learners$get("classif.rpart")
  resampling = rsmp("holdout")
  f = flt("performance", learner = learner, resampling = resampling)

  expect_equal(f$measure$id, "classif.ce")
  f$calculate(task)
  expect_filter(f, task = task)
  expect_true(all(f$scores <= 0)) # default measure is classif.error

  f = flt("performance", learner = learner, resampling = resampling,
           measure = msr("classif.acc")) # change measure
  expect_equal(f$measure$id, "classif.acc")
  f$calculate(task)
  expect_filter(f, task = task)
  expect_true(all(f$scores >= 0))
})
