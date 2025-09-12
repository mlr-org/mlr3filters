test_that("filter boruta works", {
  task = tsk("sonar")
  f = flt("boruta")
  f$calculate(task)
  expect_filter(f, task = task)
})

test_that("filter boruta works with factors", {
  task = tsk("breast_cancer")
  f = flt("boruta")
  f$calculate(task)
  expect_filter(f, task = task)
})
