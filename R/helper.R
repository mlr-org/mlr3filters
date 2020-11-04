reencode_praznik_score = function(x) {
  scores = x$score
  n = length(scores)
  set_names(rev(seq_len(n)) / n, names(scores))
}
