test_that("FilterImportance", {
  set.seed(42)
  task = mlr3::mlr_tasks$get("wine")
  learner = mlr3::mlr_learners$get("classif.rpart")
  f = FilterImportance$new(learner = learner)
  f$calculate(task)
  expect_filter(f, task = task)
})

test_that("task_types check", {
  task = mlr3::tsk("mtcars")
  filter = flt("importance", learner = mlr3::lrn("classif.featureless"))

  expect_error(
    filter$calculate(task),
    "type"
  )
})
