context("Filter")

test_that("Filtering an empty Task (#39)", {
  task = mlr_tasks$get("mtcars")
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique")

  task = mlr_tasks$get("mtcars")$select(character())
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique", len = 0)

  task = mlr_tasks$get("mtcars")$filter(character())
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique", len = length(task$feature_names))
  expect_true(allMissing(f$scores))
})
