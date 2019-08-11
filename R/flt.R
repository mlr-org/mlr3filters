#' @title Syntactic Sugar for Filter Construction
#'
#' @description
#' This function complements [mlr_filters] with a function in the spirit of [mlr3::mlr_sugar].
#'
#' @inheritParams mlr3::mlr_sugar
#' @return [Filter].
#' @export
#' @examples
#' flt("correlation", method = "kendall")
flt = function(.key, ...) {
  dictionary_sugar(mlr_filters, .key, ...)
}
