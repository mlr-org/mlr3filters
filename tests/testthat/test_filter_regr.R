context("regr")

test_that("all regr filters return correct filter values", {
  filter_all_regr = create_filters_custom("regr")

  foo = map(filter_all_regr, function(.x) {
    .x$calculate(task)
    expect_data_table(.x$scores)
    expect_equal(ncol(.x$scores), 2)
    expect_named(.x$scores, c("score", "feature"))
  })
})

test_that("'nfeat' argument works correctly with different values of 'type'", {
  filter_all_regr = create_filters_custom("regr", param_vals = list(nfeat = 0.5))

  foo = map(filter_all_regr, function(.x) {
    .x$calculate(task)
    expect_data_table(.x$scores)
    # only 5 out of 10 should be returned
    expect_equal(nrow(.x$scores), 5)

    # when n > nfeat
    expect_warning(.x$get_best(7, type = "abs"))
    expect_error(.x$get_best(7, type = "frac"))
  })
})

test_that("Errors for unsupported features", {

  # list filters that only support "numeric" features
  filters = mlr_filters$mget(mlr_filters$keys())
  filters = Filter(function(x) all(grepl(paste(c("numeric", "integer"),
      collapse = "|"), x$feature_types)), filters)
  filters = filters[lengths(filters) != 0]

  # supported: numeric, integer
  # supplied: factor, integer, numeric
  foo = map(filters, function(.x) {
    expect_error(.x$calculate(task_bh))
  })
})
