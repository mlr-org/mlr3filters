test_that("FilterCorrelation handles features with only missings gracefully", {
  data = as.data.table(mtcars)
  data[, disp := NA]
  task = as_task_regr(data, target = "mpg")

  scores = flt("correlation")$calculate(task)$scores

  expect_numeric(scores)
  expect_true(is.na(scores["disp"]))
  expect_true(all(!is.na(scores[setdiff(names(scores), "disp")])))
})
