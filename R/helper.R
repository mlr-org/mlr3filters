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

# extract values from a single column of a data table
# tries to avoid the overhead of data.table for small tables
fget = function(tab, i, j, key) {
  if (nrow(tab) > 1000L) {
    ijoin(tab, i, j, key)[[1L]]
  } else {
    x = tab[[key]]
    if (is.character(x) && is.character(i)) {
      tab[[j]][x %chin% i]
    } else {
      tab[[j]][x %in% i]
    }
  }
}

ijoin = function(tab, .__i__, .__j__, .__key__) {
  if (!is.list(.__i__)) {
    .__i__ = list(.__i__)
  }
  tab[.__i__, .__j__, with = FALSE, nomatch = NULL, on = .__key__]
}
