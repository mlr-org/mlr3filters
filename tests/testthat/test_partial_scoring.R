context("partial scoring")

test_that("praznik 'nfeat' argument works correctly", {
  task = mlr_tasks$get("mtcars")
  filters = mlr_filters$mget(as.data.table(mlr_filters)[map_lgl(packages, is.element, el = "praznik"), key])
  nfeat = 3

  for (f in filters) {
    f$calculate(task, nfeat = nfeat)
    expect_equal(sum(!is.na(f$scores)), nfeat)
    expect_filter(f, task = task)
  }
})
