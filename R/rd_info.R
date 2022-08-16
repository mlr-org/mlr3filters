#' @export
rd_info.Filter = function(obj, section) { # nolint
  x = c("",
    sprintf("* Task types: %s", rd_format_string(obj$task_type)),
    sprintf("* Feature types: %s", rd_format_string(obj$feature_types)),
    sprintf("* Packages: %s", rd_format_string(obj$packages))
  )
  paste(x, collapse = "\n")
}
