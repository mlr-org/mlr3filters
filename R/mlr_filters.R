#' @title Dictionary of Filters
#'
#' @format [R6Class] object
#' @description
#' A simple [Dictionary] storing objects of class [Filter].
#' Each Filter has an associated help page, see `mlr_filters_[id]`.
#'
#' @section Usage:
#'
#' See [Dictionary].
#'
#' @family Dictionary
#' @family Filter
#' @name mlr_filters
#' @examples
#' mlr_filters$keys()
#' as.data.table(mlr_filters)
#' mlr_filters$get("mim")
NULL

#' @export
mlr_filters = DictionaryFilter = R6Class("DictionaryFilter",
  inherit = mlr3misc::Dictionary,
  cloneable = FALSE,
  public = list(
    get = function(key, ..., id = NULL, param_vals = NULL) {
      obj = super$get(key, ...)
      if (!is.null(id)) {
        obj$id = id
      }
      if (!is.null(param_vals)) {
        obj$param_set$values = insert_named(obj$param_set$values, param_vals)
      }
      obj
    }

  )
)$new()


#' @export
as.data.table.DictionaryFilter = function(x, ...) {
  setkeyv(map_dtr(x$keys(), function(key) {
    l = x$get(key)
    list(
      key = key,
      task_type = list(l$task_type),
      task_properties = list(l$task_properties),
      param_set = list(l$param_set),
      feature_types = list(l$feature_types),
      packages = list(l$packages)
    )
  }), "key")[]
}
