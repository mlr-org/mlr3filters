#' @title Gaussian Covariate Stepwise Selection
#'
#' @name mlr_filters_gauscovf1st
#'
#' @description Gaussian covariate filter calling
#'   [gausscov::f1st()] in package \CRANpkg{gausscov}. Please read
#'   original documentation for the function form the \CRANpkg{gausscov}
#'   package.
#'
#'   Filter supports only regression tasks.
#'
#' @family Filter
#' @template seealso_filter
#' @export
#' @examples
#' if (requireNamespace("FilterGausscovF1st")) {
#'   ## Gaussian Covariance (default)
#'   task = mlr3::tsk("mtcars")
#'   filter = flt("gausscov_f1st")
#'   filter$calculate(task)
#'   head(filter$scores, 3)
#'   as.data.table(filter)
#' }
FilterGausscovF1st = R6Class(
  "FilterGausscovF1st",
  inherit = Filter,

  public = list(

    #' @description Create a GaussCov object.
    initialize = function() {
      param_set = ps(
        p0   = p_dbl(lower = 0, upper = 1, default = 0.01),
        kmn  = p_int(lower = 0, default = 0),
        kmx  = p_int(lower = 0, default = 0),
        mx   = p_int(lower = 1, default = 21),
        kex  = p_int(lower = 1, default = 0),
        sub  = p_lgl(default = TRUE),
        inr  = p_lgl(default = TRUE),
        xinr = p_lgl(default = FALSE),
        qq   = p_int(lower = 1, default = 0)
      )

      super$initialize(
        id = "gausscov_f1st",
        task_types = c("regr"),
        param_set = param_set,
        feature_types = c("integer", "numeric"),
        packages = "gausscov",
        label = "Gauss Covariance f1st",
        man = "mlr3filters::mlr_filters_gausscov_f1st"
      )
    }
  ),

  private = list(
    .calculate = function(task, nfeat) {
      pv = self$param_set$values
      x = as.matrix(task$data(cols = task$feature_names))
      y = as.matrix(task$truth())
      res = invoke(gausscov::f1st, y = y, x = x, .args = pv)
      res_1 = res[[1]]
      res_1 = res_1[res_1[, 1] != 0, ]
      scores = res_1[, 2]
      attrs = task$feature_names[res_1[, 1]]
      set_names(scores, attrs)
    }
  )
)

#' @include mlr_filters.R
mlr_filters$add("gausscov_f1st", FilterGausscovF1st)
