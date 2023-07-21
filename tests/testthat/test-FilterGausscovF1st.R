test_that("FilterGaussCovF1st works as expected", {
  data = as.data.table(mtcars)
  task = as_task_regr(data, target = "mpg")

  scores = flt("gausscov_f1st")$calculate(task)$scores

  expect_numeric(scores)
})
