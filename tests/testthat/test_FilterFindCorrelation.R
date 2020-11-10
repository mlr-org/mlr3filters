test_that("FilterImportance", {
  task = mlr3::mlr_tasks$get("sonar")
  equalcor = cbind(
    a = rep(c(1, 0, 0, 0), task$nrow / 4), b = c(0, 1, 0, 0),
    c = c(0, 0, 1, 0), d = c(0, 0, 0, 1), e = c(0.1, -0.1, 0.1, 0.99),
    f = c(-0.1, 0.1, 0.1, 0.99))
  task$cbind(as.data.frame(equalcor))
  data = task$data(cols = task$feature_names)
  cm = cor(data)
  checkpoints = (0:100) / 100
  remove_caret = lapply(checkpoints, caret::findCorrelation, x = cm, exact = FALSE)
  f = FilterFindCorrelation$new()
  f$calculate(task)
  remove_filter = lapply(checkpoints, function(cutoff) {
    match(names(f$scores)[f$scores < 1 - cutoff], task$feature_names)
  })
  mapply(expect_set_equal, remove_caret, remove_filter)
})
