test_that("FilterRelief handles features with only missings gracefully", {
  data = tsk("mtcars")$data()
  data[, wt := NA]
  task = as_task_regr(data, target = "mpg")

  scores = flt("relief")$calculate(task)$scores

  expect_numeric(scores, any.missing = FALSE)
  expect_lte(scores["wt"], 1e-8)
})

test_that("FilterRelief handles features with only missings gracefully", {
  data = tsk("iris")$data()
  data[, Sepal.Length := NA]
  task = as_task_classif(data, target = "Species")

  scores = flt("relief")$calculate(task)$scores

  expect_numeric(scores, any.missing = FALSE)
  expect_lte(scores["Sepal.Length"], 1e-8)
})
