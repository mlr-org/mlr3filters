#' @title Dictionary of Filters
#'
#' @format [R6::R6Class] object
#' @description
#' A simple [mlr3misc::Dictionary] storing objects of class [Filter].
#' Each Filter has an associated help page, see `mlr_filters_[id]`.
#'
#' This dictionary can get populated with additional filters by add-on packages.
#'
#' For a more convenient way to retrieve and construct filters, see [flt()].
#' @section Usage:
#'
#' See [mlr3misc::Dictionary].
#'
#' @family Dictionary
#' @family Filter
#' @export
#' @examples
#' mlr_filters$keys()
#' as.data.table(mlr_filters)
#' mlr_filters$get("mim")
#' flt("anova")
mlr_filters = DictionaryFilter = R6Class("DictionaryFilter",
  inherit = mlr3misc::Dictionary,
  cloneable = FALSE,
)$new()


#' @export
as.data.table.DictionaryFilter = function(x, ..., objects = FALSE) {
  assert_flag(objects)

  setkeyv(map_dtr(x$keys(), function(key) {
    f = x$get(key)
    insert_named(
      list(key = key, label = f$label, task_types = list(f$task_types),
        task_properties = list(f$task_properties), params = list(f$param_set$ids()),
        feature_types = list(f$feature_types), packages = list(f$packages)),
      if (objects) list(object = list(f))
    )
  }), "key")[]
}
