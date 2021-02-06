call_praznik = function(self, task, fun) {
  selection = invoke(fun,
    X = task$data(cols = task$feature_names),
    Y = task$truth(),
    .args = self$param_set$get_values()
  )$selection

  set_names(seq(from = 1, to = 0, length.out = length(selection)), names(selection))
}
