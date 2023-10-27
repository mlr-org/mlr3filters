skip_if_not_installed("mlr3proba")

test_that("FilterUnivariateCox", {
  t = tsk("rats")
  f = flt("univariatecox")
  f$calculate(t)

  expect_filter(f, task = t)
  expect_true(all(f$scores >= 0))

  # works with 2-level factors (but not 3-level ones)
  feature = "sex"
  expect_class(t$data(cols = feature)[[1]], "factor")

  l = lrn("surv.coxph")
  t2 = t$clone()
  t2$col_roles$feature = feature
  l$train(t2)

  expect_equal(-log(summary(l$model)$coefficients[,"Pr(>|z|)"]), f$scores[[feature]])
})
