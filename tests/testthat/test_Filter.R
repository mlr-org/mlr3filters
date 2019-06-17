context("Filter")

test_that("Errors for unsupported features", {
  # supported: numeric
  # supplied: factor, integer, numeric
  task = mlr3::mlr_tasks$get("boston_housing")
  filter = FilterLinearCorrelation$new()
  expect_error(filter$calculate(task))
})

test_that("fr$combine()", {

  task = mlr3::mlr_tasks$get("iris")

  # create filters
  fr_new = FilterMIM$new()
  fr_new$calculate(task)
  fr_new2 = FilterVariance$new()
  fr_new2$calculate(task)

  fr_comb = fr_new$combine(fr_new2)

  expect_filter_result(fr_new)
  expect_filter_result(fr_new2)
  expect_filter_result(fr_comb)

  expect_data_table(fr_new$scores, nrow = 4)
  expect_data_table(fr_new2$scores, nrow = 4)
  expect_data_table(fr_comb$scores, nrow = 8)

})
