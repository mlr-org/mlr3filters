context("FilterEmbedded")

test_that("FilterEmbedded", {
  task = mlr3::mlr_tasks$get("wine")
  learner = mlr3::mlr_learners$get("classif.rpart")
  f = FilterEmbedded$new(learner = learner)
  f$calculate(task)
  expect_filter(f, task = task)
})
