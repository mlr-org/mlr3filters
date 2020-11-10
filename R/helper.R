reencode_praznik_score = function(x) {
  scores = x$score
  set_names(seq(from = 1, to = 0, length.out = length(scores)), names(scores))
}
