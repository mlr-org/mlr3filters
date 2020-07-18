context("FilterPermutation")

test_that("FilterPermutation", {
  task = mlr3::mlr_tasks$get("iris")
  learner = mlr3::mlr_learners$get("classif.rpart")
  resampling = mlr3::rsmp("cv", folds = 2)
  f = flt("permutation", learner = learner, resampling = resampling, nmc = 3)

  f$calculate(task)
  expect_filter(f, task = task)
})
