skip_if_not_installed("mlr3proba")

test_that("FilterUnivariateCox", {
  t = tsk("rats")
  t2 = t$clone()$select(c("rx", "litter"))
  f = flt("univariatecox")
  f$calculate(t2)

  # simple testing of filter scores
  expect_filter(f, task = t2)
  expect_true(all(f$scores >= 0))

  # doesn't work with factors (feature: sex)
  expect_error(f$calculate(t), "unsupported feature types: factor")

  # encode sex as numeric so filter can be used
  dt = t$data()
  dt[, sex := ifelse(dt[["sex"]] == 'm', 1, 0)]
  t3 = mlr3proba::as_task_surv(dt, target = "time", event = "status")
  f$calculate(t3)
  score = f$scores[["sex"]]

  # get manually score on sex factor
  l = lrn("surv.coxph")
  t$col_roles$feature = "sex"
  l$train(t)
  manual_score = -log10(summary(l$model)$coefficients[,"Pr(>|z|)"])

  # for 2-level factors, same result is returned if 0-1 encoded
  expect_equal(manual_score, score)
})
