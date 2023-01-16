test_that("FilterKruskalTest handles features with only missings gracefully", {
  data = tsk("spam")$data()
  data[, report := NA]
  data[1, report := 1]
  task = as_task_classif(data, target = "type")

  scores = flt("kruskal_test")$calculate(task)$scores

  expect_numeric(scores)
  expect_true(is.na(scores["disp"]))
  expect_true(all(!is.na(scores[setdiff(names(scores), "report")])))
})
