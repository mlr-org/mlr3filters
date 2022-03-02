test_that("FilterPerformance", {
  task = mlr3::mlr_tasks$get("iris")
  learner = mlr3::mlr_learners$get("classif.rpart")
  resampling = rsmp("holdout")
  f = flt("performance", learner = learner, resampling = resampling)

  f$calculate(task)
  expect_filter(f, task = task)
  expect_true(all(f$scores < 0))
})
