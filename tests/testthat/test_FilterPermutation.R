test_that("FilterPermutation default (resample method)", {
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 2)
  f <- flt("permutation", learner = learner, resampling = resampling, nmc = 3)

  # Check that default is "resample"
  expect_equal(f$param_set$default$method, "resample")
  f$calculate(task)
  expect_filter(f, task = task)
})

test_that("FilterPermutation with method='predict'", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 2)
  f <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 3, method = "predict"
  )

  expect_equal(f$param_set$values$method, "predict")
  f$calculate(task)
  expect_filter(f, task = task)
})

test_that("FilterPermutation both methods produce valid scores", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 2)

  # Calculate with resample method
  f_resample <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 5, method = "resample"
  )
  f_resample$calculate(task)
  scores_resample <- f_resample$scores

  # Calculate with predict method
  f_predict <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 5, method = "predict"
  )
  f_predict$calculate(task)
  scores_predict <- f_predict$scores

  # Both methods should produce valid numeric scores for all features
  expect_equal(length(scores_resample), length(scores_predict))
  expect_true(all(is.numeric(scores_resample)))
  expect_true(all(is.numeric(scores_predict)))
  # Both should have same feature names (regardless of order)
  expect_equal(setequal(names(scores_resample), names(scores_predict)), TRUE)
})

test_that("FilterPermutation parameter validation", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 2)

  # Default should be "resample"
  f <- flt("permutation", learner = learner, resampling = resampling, nmc = 2)
  expect_equal(f$param_set$default$method, "resample")

  # Test method parameter with both values
  for (method in c("resample", "predict")) {
    f <- flt("permutation",
      learner = learner, resampling = resampling,
      nmc = 2, method = method
    )
    expect_equal(f$param_set$values$method, method)
  }
})

test_that("FilterPermutation with standardize and method='predict'", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 2)
  f <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 3, method = "predict", standardize = TRUE
  )

  f$calculate(task)
  expect_filter(f, task = task)
  # Check that max score is close to 1 when standardized
  expect_true(max(f$scores) <= 1.01) # Allow small numerical error
})

test_that("FilterPermutation warning for resample method", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 3)
  f <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 5, method = "resample"
  )

  # Should warn about training many models
  expect_warning(f$calculate(task),
    regexp = "will train.*models"
  )
})

test_that("FilterPermutation no warning for predict method", {
  skip_if_not_installed("rpart")
  task <- mlr3::mlr_tasks$get("iris")
  learner <- mlr3::mlr_learners$get("classif.rpart")
  resampling <- mlr3::rsmp("cv", folds = 3)
  f <- flt("permutation",
    learner = learner, resampling = resampling,
    nmc = 5, method = "predict"
  )

  # Should NOT warn
  expect_no_warning(f$calculate(task))
})
