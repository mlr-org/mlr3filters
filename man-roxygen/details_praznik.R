#' @details
#' As the scores calculated by the \CRANpkg{praznik} package are not monotone due
#' to the greedy forward fashion, the returned scores simply reflect the selection order:
#' `1`, `(k-1)/k`, ..., `1/k` where `k` is the number of selected features.
#'
#' Threading is disabled by default (hyperparameter `threads` is set to 1).
#' Set to a number `>= 2` to enable threading, or to `0` for auto-detecting the number
#' of available cores.
