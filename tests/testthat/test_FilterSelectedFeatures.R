test_that("FilterSelectedFeatures", {
  set.seed(42)
  task = mlr3::mlr_tasks$get("wine")
  learner = mlr3::mlr_learners$get("classif.rpart")
  f = FilterSelectedFeatures$new(learner = learner)
  f$calculate(task)
  expect_filter(f, task = task)
})
