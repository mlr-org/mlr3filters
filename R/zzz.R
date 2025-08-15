#' @import data.table
#' @import checkmate
#' @import paradox
#' @import mlr3misc
#' @import mlr3
#' @importFrom R6 R6Class
#' @importFrom utils head
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  # nolint
  # nocov start
  x = utils::getFromNamespace("mlr_reflections", ns = "mlr3")
  x$filter_properties = "missings"  # only allow missings for now
  backports::import(pkgname)
} # nocov end

leanify_package()
