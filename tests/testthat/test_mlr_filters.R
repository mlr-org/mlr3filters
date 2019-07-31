context("mlr_filters")

test_that("mlr_filters", {
  expect_dictionary(mlr_filters, min_items = 1)
})
