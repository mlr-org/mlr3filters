test_that("Filtering an empty Task (#39)", {
  task = mlr_tasks$get("mtcars")
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique")

  task = mlr_tasks$get("mtcars")$select(character())
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique", len = 0)

  no_ids = task$row_ids[0]
  task = mlr_tasks$get("mtcars")$filter(no_ids)
  f = mlr_filters$get("variance")
  f$calculate(task)
  expect_numeric(f$scores, names = "unique", len = length(task$feature_names))
  expect_true(allMissing(f$scores))
})

test_that("as.data.table conversion works", {
  task = mlr_tasks$get("pima")
  filter = mlr_filters$get("auc")
  filter$calculate(task)

  expect_silent(as.data.table(filter))
})

test_that("mlr3sugar creation works", {
  expect_silent(flt("correlation", method = "kendall"))
})

test_that("Assertion of task type works", {
  task = mlr_tasks$get("iris")
  f = mlr_filters$get("correlation")
  expect_error(f$calculate(task), regexp = "must be numeric")
})


test_that("nfeat is passed to praznik correctly", {
  skip_if_not_installed("praznik")
  task = tsk("iris")
  f = flt("disr")
  f$calculate(task, nfeat = 1)
  expect_equal(sum(!is.na(f$scores)), 1)
})
