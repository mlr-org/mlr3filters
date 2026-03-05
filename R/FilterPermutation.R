#' @title Permutation Score Filter
#'
#' @name mlr_filters_permutation
#'
#' @description
#' The permutation filter randomly permutes the values of a single feature in a
#' [mlr3::Task] to break the association with the response. The permutation filter
#' score is the difference between the baseline performance and the performance when
#' a feature is randomly permuted. This approach, introduced by Breiman (2001) for
#' Random Forests, measures feature importance by the increase in prediction error
#' when a feature's values are shuffled, thereby breaking its association with the
#' target while keeping all other features intact.
#'
#' Two computational strategies are available:
#' - `method = "resample"`: Resamples the model for each permutation (slower, more
#'   robust, recommended for small datasets). This trains `nmc * nfeatures * nfolds`
#'   models.
#' - `method = "predict"`: Trains the model once, then permutes features in test
#'   predictions only (faster, recommended for large datasets). This trains only
#'   `nfolds` models.
#'
#' @section Parameters:
#' \describe{
#' \item{`standardize`}{`logical(1)`\cr
#' Standardize feature importance by maximum score.}
#' \item{`nmc`}{`integer(1)`}\cr
#' Number of Monte-Carlo iterations to use in computing the feature importance.}
#' \item{`method`}{`character(1)`\cr
#' Computational method: `"resample"` (default, backward-compatible) resamples
#' the full model per permutation; `"predict"` trains once and permutes in
#' predictions only (much faster).}
#' }
#'
#' @references
#' `r format_bib("breiman_2001")`
#'
#' @family Filter
#' @include FilterLearner.R
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("rpart")) {
#'   learner = mlr3::lrn("classif.rpart")
#'   resampling = mlr3::rsmp("holdout")
#'   measure = mlr3::msr("classif.acc")
#'
#'   # Standard resample method (more robust, slower)
#'   filter = flt("permutation", learner = learner, measure = measure,
#'     resampling = resampling, nmc = 2)
#'   task = mlr3::tsk("iris")
#'   filter$calculate(task)
#'   as.data.table(filter)
#' }
#'
#' if (requireNamespace("rpart")) {
#'   # Efficient predict method (most real world use cases)
#'   learner = mlr3::lrn("classif.rpart")
#'   resampling = mlr3::rsmp("cv", folds = 5)
#'   measure = mlr3::msr("classif.acc")
#'
#'   filter = flt("permutation", learner = learner, measure = measure,
#'     resampling = resampling, method = "predict", nmc = 10)
#'   task = mlr3::tsk("iris")
#'   filter$calculate(task)
#'   as.data.table(filter)
#' }
#'
#' if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
#'   library("mlr3pipelines")
#'   task = mlr3::tsk("iris")
#'
#'   # Pipeline with efficient permutation importance
#'   graph = po("filter", filter = flt("permutation", method = "predict", nmc = 5),
#'     filter.frac = 0.5) %>>%
#'     po("learner", mlr3::lrn("classif.rpart"))
#'
#'   graph$train(task)
#' }
FilterPermutation = R6Class("FilterPermutation",
  inherit = FilterLearner,
  public = list(

    #' @field learner ([mlr3::Learner])\cr
    learner = NULL,
    #' @field resampling ([mlr3::Resampling])\cr
    resampling = NULL,
    #' @field measure ([mlr3::Measure])\cr
    measure = NULL,

    #' @description Create a FilterPermutation object.
    #' @param learner ([mlr3::Learner])\cr
    #'   [mlr3::Learner] to use for model fitting.
    #' @param resampling ([mlr3::Resampling])\cr
    #'   [mlr3::Resampling] to be used within resampling.
    #' @param measure ([mlr3::Measure])\cr
    #'   [mlr3::Measure] to be used for evaluating the performance.
    initialize = function(learner = mlr3::lrn("classif.featureless"), resampling = mlr3::rsmp("holdout"),
      measure = NULL) {

      param_set = ps(
        standardize = p_lgl(default = FALSE),
        nmc         = p_int(lower = 1L, default = 50L),
        method      = p_fct(levels = c("resample", "predict"), default = "resample")
      )

      self$learner = learner = assert_learner(as_learner(learner, clone = TRUE))
      self$resampling = assert_resampling(as_resampling(resampling), instantiated = FALSE)
      self$measure = assert_measure(as_measure(measure,
        task_type = learner$task_type, clone = TRUE), learner = learner)
      packages = unique(c(self$learner$packages, self$measure$packages))

      super$initialize(
        id = "permutation",
        task_types = learner$task_type,
        feature_types = learner$feature_types,
        packages = packages,
        param_set = param_set,
        label = "Permutation Score",
        man = "mlr3filters::mlr_filters_permutation"
      )
    }
  ),

  active = list(
    #' @field hash (`character(1)`)\cr
    #' Hash (unique identifier) for this object.
    hash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$param_set$values, self$learner$hash,
        self$resampling$hash, self$measure$hash)
    },

    #' @field phash (`character(1)`)\cr
    #' Hash (unique identifier) for this partial object, excluding some components
    #' which are varied systematically during tuning (parameter values) or feature
    #' selection (feature names).
    phash = function(rhs) {
      assert_ro_binding(rhs)
      calculate_hash(class(self), self$id, self$learner$hash, self$resampling$hash,
        self$measure$hash)
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      task = task$clone()
      fn = task$feature_names
      nmc = self$param_set$values$nmc %??% 50L
      method = self$param_set$values$method %??% "resample"

      # Warn about computational cost for resample method
      if (method == "resample") {
        n_models = nmc * length(fn) * self$resampling$iters
        warn_message = sprintf(
          "Using method='resample' will train %d models (%d features x %d MC iterations x %d folds). ",
          n_models, length(fn), nmc, self$resampling$iters
        )
        warn_message = paste0(warn_message,
          "For faster computation, consider method='predict' which trains only ",
          self$resampling$iters, " models and permutes in predictions only.")
        warning(warn_message, call. = FALSE)
      }

      if (method == "resample") {
        private$.calculate_resample(task, fn, nmc)
      } else if (method == "predict") {
        private$.calculate_predict(task, fn, nmc)
      }
    },

    .calculate_resample = function(task, fn, nmc) {
      # Original slow method: retrain per permutation
      backend = task$backend
      rr = resample(task, self$learner, self$resampling)
      baseline = rr$aggregate(self$measure)

      perf = matrix(NA_real_, nrow = nmc, ncol = length(fn),
        dimnames = list(NULL, fn))

      for (j in seq_col(perf)) {
        data = task$data(cols = fn[j])

        for (i in seq_row(perf)) {
          data[[1L]] = shuffle(data[[1L]])
          task$cbind(data)
          rr = resample(task, self$learner, self$resampling)
          perf[i, j] = rr$aggregate(self$measure)

          # reset to previous backend
          task$backend = backend
        }
      }

      delta = baseline - colMeans(perf)
      if (self$measure$minimize) {
        delta = -delta
      }
      if (isTRUE(self$param_set$values$standardize)) {
        delta = delta / max(delta)
      }
      delta
    },

    .calculate_predict = function(task, fn, nmc) {
      # Fast method: train once, permute in predictions only
      # Step 1: Train learners for each fold and compute baselines
      resampling = self$resampling$clone()
      resampling$instantiate(task)
      nfolds = resampling$iters

      # Train learners and compute baseline per-fold
      trained_learners = list()
      baseline_perfs = numeric(nfolds)

      for (k in seq_len(nfolds)) {
        # Get training set for this fold
        train_rows = resampling$train_set(k)
        train_task = task$clone()
        train_task$filter(rows = train_rows)

        # Train learner on this fold
        learner_clone = self$learner$clone()
        learner_clone$train(train_task)
        trained_learners[[k]] = learner_clone

        # Get baseline prediction on test data
        test_rows = resampling$test_set(k)
        test_data = task$data(rows = test_rows)
        pred = learner_clone$predict_newdata(newdata = test_data)
        baseline_perfs[k] = self$measure$score(pred)
      }

      baseline = mean(baseline_perfs)

      # Initialize performance matrix
      perf = matrix(NA_real_, nrow = nmc, ncol = length(fn),
        dimnames = list(NULL, fn))

      # Step 2: For each feature, permute in test predictions
      for (j in seq_along(fn)) {
        feat_name = fn[j]

        for (i in seq_len(nmc)) {
          # Collect predictions across all folds with permuted feature
          fold_perfs = numeric(nfolds)

          for (k in seq_len(nfolds)) {
            # Get test indices for this fold from resampling
            test_rows = resampling$test_set(k)

            # Extract test data (all columns)
            test_data = task$data(rows = test_rows)

            # Create permuted copy of the feature column
            perm_data = data.table::copy(test_data)
            perm_data[[feat_name]] = shuffle(perm_data[[feat_name]])

            # Get predictions from trained learner on permuted data
            pred = trained_learners[[k]]$predict_newdata(newdata = perm_data)

            # Compute loss for this fold
            fold_perfs[k] = self$measure$score(pred)
          }

          # Average performance across folds
          perf[i, j] = mean(fold_perfs)
        }
      }

      delta = baseline - colMeans(perf)
      if (self$measure$minimize) {
        delta = -delta
      }
      if (isTRUE(self$param_set$values$standardize)) {
        delta = delta / max(delta)
      }
      delta
    },

    .get_properties = function() {
      intersect("missings", self$learner$properties)
    }
  )

)

#' @include mlr_filters.R
mlr_filters$add("permutation", FilterPermutation)
