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
  backports::import(pkgname)
} # nocov end
