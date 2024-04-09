test_that("filter boruta works", {
  task = tsk("sonar")
  f = flt("boruta")
  f$calculate(task)
  expect_filter(f, task = task)
})
