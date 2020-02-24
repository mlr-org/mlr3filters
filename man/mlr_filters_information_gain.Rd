% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterInformationGain.R
\name{mlr_filters_information_gain}
\alias{mlr_filters_information_gain}
\alias{FilterInformationGain}
\title{Information Gain Filter}
\format{\link[R6:R6Class]{R6::R6Class} inheriting from \link{Filter}.}
\description{
Information gain filter calling
\code{\link[FSelectorRcpp:information_gain]{FSelectorRcpp::information_gain()}} in package \CRANpkg{FSelectorRcpp}. Set
parameter \code{"type"} to \code{"gainratio"} to calculate the gain ratio, or set to
\code{"symuncert"} to calculate the symmetrical uncertainty (see
\code{\link[FSelectorRcpp:information_gain]{FSelectorRcpp::information_gain()}}). Default is \code{"infogain"}.

Argument \code{equal} defaults to \code{FALSE} for classification tasks, and to
\code{TRUE} for regression tasks.
}
\section{Construction}{
\preformatted{FilterInformationGain$new()
mlr_filters$get("information_gain")
flt("information_gain")
}
}

\examples{
## InfoGain (default)
task = mlr3::tsk("pima")
filter = flt("information_gain")
filter$calculate(task)
head(filter$scores, 3)
as.data.table(filter)

## GainRatio

filterGR = flt("information_gain")
filterGR$param_set$values = list("type" = "gainratio")
filterGR$calculate(task)
head(as.data.table(filterGR), 3)
}
\seealso{
\link[mlr3misc:Dictionary]{Dictionary} of \link[=Filter]{Filters}: \link{mlr_filters}

Other Filter: 
\code{\link{Filter}},
\code{\link{mlr_filters_anova}},
\code{\link{mlr_filters_auc}},
\code{\link{mlr_filters_carscore}},
\code{\link{mlr_filters_cmim}},
\code{\link{mlr_filters_correlation}},
\code{\link{mlr_filters_disr}},
\code{\link{mlr_filters_find_correlation}},
\code{\link{mlr_filters_jmim}},
\code{\link{mlr_filters_jmi}},
\code{\link{mlr_filters_kruskal_test}},
\code{\link{mlr_filters_mim}},
\code{\link{mlr_filters_mrmr}},
\code{\link{mlr_filters_njmim}},
\code{\link{mlr_filters_performance}},
\code{\link{mlr_filters_variable_importance}},
\code{\link{mlr_filters_variance}},
\code{\link{mlr_filters}}
}
\concept{Filter}