% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterCarSurvScore.R
\name{mlr_filters_carsurvscore}
\alias{mlr_filters_carsurvscore}
\alias{FilterCarSurvScore}
\title{Correlation-Adjusted Survival Score Filter}
\description{
Calculates CARS scores for right-censored survival tasks.
Calls the implementation in \code{\link[carSurv:carSurvScore]{carSurv::carSurvScore()}} in package
\CRANpkg{carSurv}.
}
\examples{
if (requireNamespace("mlr3proba")) {
  task = mlr3::tsk("gbcs")
  filter = flt("carsurvscore")
  filter$calculate(task)
  head(as.data.table(filter), 3)
}
}
\references{
Bommert A, Welchowski T, Schmid M, Rahnenführer J (2021).
\dQuote{Benchmark of filter methods for feature selection in high-dimensional gene expression survival data.}
\emph{Briefings in Bioinformatics}, \bold{23}(1).
\doi{0.1093/bib/bbab354}.
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
\code{\link{mlr_filters_importance}},
\code{\link{mlr_filters_information_gain}},
\code{\link{mlr_filters_jmim}},
\code{\link{mlr_filters_jmi}},
\code{\link{mlr_filters_kruskal_test}},
\code{\link{mlr_filters_mim}},
\code{\link{mlr_filters_mrmr}},
\code{\link{mlr_filters_njmim}},
\code{\link{mlr_filters_performance}},
\code{\link{mlr_filters_permutation}},
\code{\link{mlr_filters_relief}},
\code{\link{mlr_filters_selected_features}},
\code{\link{mlr_filters_variance}},
\code{\link{mlr_filters}}
}
\concept{Filter}
\section{Super class}{
\code{\link[mlr3filters:Filter]{mlr3filters::Filter}} -> \code{FilterCarSurvScore}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{FilterCarSurvScore$new()}}
\item \href{#method-clone}{\code{FilterCarSurvScore$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="mlr3filters" data-topic="Filter" data-id="calculate">}\href{../../mlr3filters/html/Filter.html#method-calculate}{\code{mlr3filters::Filter$calculate()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3filters" data-topic="Filter" data-id="format">}\href{../../mlr3filters/html/Filter.html#method-format}{\code{mlr3filters::Filter$format()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3filters" data-topic="Filter" data-id="help">}\href{../../mlr3filters/html/Filter.html#method-help}{\code{mlr3filters::Filter$help()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="mlr3filters" data-topic="Filter" data-id="print">}\href{../../mlr3filters/html/Filter.html#method-print}{\code{mlr3filters::Filter$print()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Create a FilterCarSurvScore object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterCarSurvScore$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterCarSurvScore$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}