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

# mlr3proba
## access private environment of r6 class
r6_private = function(x) {
  x$.__enclos_env__$private
}
