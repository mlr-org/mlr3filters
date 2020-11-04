#' @details
#' As the scores calculated by the \CRANpkg{praznik} package are not monotone due
#' to the greedy forward fashion, the returned scores simply reflect the selection order:
#' `1`, `(n-1)/n`, ..., `1/n` where `n` is the number of features in the task.
