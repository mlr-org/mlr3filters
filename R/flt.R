#' @title Syntactic Sugar for Filter Construction
#'
#' @description
#' These functions complements [mlr_filters] with a function in the spirit of [mlr3::mlr_sugar].
#'
#' @inheritParams mlr3::mlr_sugar
#' @return [Filter].
#' @export
#' @examples
#' flt("correlation", method = "kendall")
#' flts(c("mrmr", "jmim"))
flt = function(.key, ...) {
  dictionary_sugar_get(mlr_filters, .key, ...)
}

#' @rdname flt
#' @export
flts = function(.keys, ...) {
  dictionary_sugar_mget(mlr_filters, .keys, ...)
}
