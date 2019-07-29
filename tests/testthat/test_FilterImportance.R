context("FilterImportance")

test_that("FilterImportance", {
  task = mlr3::mlr_tasks$get("wine")
  learner = mlr3::mlr_learners$get("classif.rpart")
  f = FilterImportance$new(learner = learner)
  f$calculate(task)
  expect_filter(f, task = task)
})
