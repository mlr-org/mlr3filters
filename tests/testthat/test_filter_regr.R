context("regr")

test_that("all regr filters return correct filter values", {

  filter_all_regr = create_filters_custom("regr")

  foo = map(filter_all_regr, function(.x) {
    print(.x$id)

    .x$calculate(task)
    expect_data_table(.x$scores)
    expect_equal(ncol(.x$scores), 2)
    expect_named(.x$scores, c("score", "feature"))
  })

})

test_that("'nfeat' argument works correctly with different values of 'type'", {

  filter_all_regr = create_filters_custom("regr", param_vals = list(nfeat = 0.5))

  foo = map(filter_all_regr, function(.x) {
    print(.x$id)
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

  filter_all_regr = create_filters_custom("regr")

  # supported: numeric
  # supplied: factor, integer, numeric
  foo = map(filter_all_regr, function(.x) {
    print(.x$id)
    expect_error(.x$calculate(task_bh))
  })
})

