skip_if_not_installed("mlr3spatiotempcv")
skip_on_cran()

test_that("task detection works with mlr3spatiotempcv tasks", {
  pkg = "mlr3spatiotempcv"
  library(pkg, character.only = TRUE) # FIXME: replace with requireNamespace()
  task = tsk("ecuador")
  learner = lrn("classif.rpart")

  filter = flt("importance", learner = learner)
  expect_filter(filter$calculate(task))

  filter = flt("variance")
  expect_filter(filter$calculate(task))

  filter = flt("mim")
  expect_filter(filter$calculate(task))
})
