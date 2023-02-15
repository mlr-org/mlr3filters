call_praznik = function(self, task, fun, nfeat) {
  selection = invoke(fun,
    X = task$data(cols = task$feature_names),
    Y = task$truth(),
    k = nfeat,
    .args = self$param_set$get_values()
  )$selection

  set_names(seq(from = 1, to = 0, length.out = length(selection)), names(selection))
}

catn = function(..., file = "") {
  cat(paste0(..., collapse = "\n"), "\n", sep = "", file = file)
}

as_numeric_matrix = function(x) {
  x = as.matrix(x)
  if (is.logical(x)) {
    storage.mode(x) = "double"
  }
  x
}

test_matching_task_type = function(task_type, object, class) {
  fget = function(tab, i, j, key) {
    x = tab[[key]]
    tab[[j]][x %chin% i]
  }

  if (is.null(task_type) || object$task_type == task_type) {
    return(TRUE)
  }

  cl_task_type = fget(mlr_reflections$task_types, task_type, class, "type")
  if (inherits(object, cl_task_type)) {
    return(TRUE)
  }

  cl_object = fget(mlr_reflections$task_types, object$task_type, class, "type")
  return(cl_task_type == cl_object)
}
