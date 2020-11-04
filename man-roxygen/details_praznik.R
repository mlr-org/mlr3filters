#' @details
#' As the scores calculated by the \CRANpkg{praznik} package are not monotone due
#' to the greedy forward fashion, the returned scores simply reflect the selection order:
#' `1`, `(k-1)/k`, ..., `1/k` where `k` is the number of selected features.
