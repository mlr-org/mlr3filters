% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Filter.R
\name{Filter}
\alias{Filter}
\title{Filter Base Class}
\description{
Base class for filters. Predefined filters are stored in the
\link[mlr3misc:Dictionary]{dictionary} \link{mlr_filters}. A Filter calculates a score
for each feature of a task. Important features get a large value and
unimportant features get a small value. Note that filter scores may also be
negative.
}
\details{
Some features support partial scoring of the feature set:
If \code{nfeat} is not \code{NULL}, only the best \code{nfeat} features are guaranteed to
get a score. Additional features may be ignored for computational reasons,
and then get a score value of \code{NA}.
}
\seealso{
Other Filter: 
\code{\link{mlr_filters}},
\code{\link{mlr_filters_anova}},
\code{\link{mlr_filters_auc}},
\code{\link{mlr_filters_boruta}},
\code{\link{mlr_filters_carscore}},
\code{\link{mlr_filters_carsurvscore}},
\code{\link{mlr_filters_cmim}},
\code{\link{mlr_filters_correlation}},
\code{\link{mlr_filters_disr}},
\code{\link{mlr_filters_find_correlation}},
\code{\link{mlr_filters_importance}},
\code{\link{mlr_filters_information_gain}},
\code{\link{mlr_filters_jmi}},
\code{\link{mlr_filters_jmim}},
\code{\link{mlr_filters_kruskal_test}},
\code{\link{mlr_filters_mim}},
\code{\link{mlr_filters_mrmr}},
\code{\link{mlr_filters_njmim}},
\code{\link{mlr_filters_performance}},
\code{\link{mlr_filters_permutation}},
\code{\link{mlr_filters_relief}},
\code{\link{mlr_filters_selected_features}},
\code{\link{mlr_filters_univariate_cox}},
\code{\link{mlr_filters_variance}}
}
\concept{Filter}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{id}}{(\code{character(1)})\cr
Identifier of the object.
Used in tables, plot and text output.}

\item{\code{label}}{(\code{character(1)})\cr
Label for this object.
Can be used in tables, plot and text output instead of the ID.}

\item{\code{task_types}}{(\code{character()})\cr
Set of supported task types, e.g. \code{"classif"} or \code{"regr"}.
Can be set to the scalar value \code{NA} to allow any task type.

For a complete list of possible task types (depending on the loaded packages),
see \code{\link[mlr3:mlr_reflections]{mlr_reflections$task_types$type}}.}

\item{\code{task_properties}}{(\code{character()})\cr
\link[mlr3:Task]{mlr3::Task}task properties.}

\item{\code{param_set}}{(\link[paradox:ParamSet]{paradox::ParamSet})\cr
Set of hyperparameters.}

\item{\code{feature_types}}{(\code{character()})\cr
Feature types of the filter.}

\item{\code{packages}}{(\code{\link[=character]{character()}})\cr
Packages which this filter is relying on.}

\item{\code{man}}{(\code{character(1)})\cr
String in the format \verb{[pkg]::[topic]} pointing to a manual page for this object.
Defaults to \code{NA}, but can be set by child classes.}

\item{\code{scores}}{Stores the calculated filter score values as named numeric vector.
The vector is sorted in decreasing order with possible \code{NA} values
last. The more important the feature, the higher the score.
Tied values (this includes \code{NA} values) appear in a random,
non-deterministic order.}
}
\if{html}{\out{</div>}}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{properties}}{(\code{\link[=character]{character()}})\cr
Properties of the filter. Currently, only \code{"missings"} is supported.
A filter has the property \code{"missings"}, iff the filter can handle missing values
in the features in a graceful way. Otherwise, an assertion is thrown if missing
values are detected.}

\item{\code{hash}}{(\code{character(1)})\cr
Hash (unique identifier) for this object.}

\item{\code{phash}}{(\code{character(1)})\cr
Hash (unique identifier) for this partial object, excluding some components
which are varied systematically during tuning (parameter values) or feature
selection (feature names).}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Filter-new}{\code{Filter$new()}}
\item \href{#method-Filter-format}{\code{Filter$format()}}
\item \href{#method-Filter-print}{\code{Filter$print()}}
\item \href{#method-Filter-help}{\code{Filter$help()}}
\item \href{#method-Filter-calculate}{\code{Filter$calculate()}}
\item \href{#method-Filter-clone}{\code{Filter$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-new"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-new}{}}}
\subsection{Method \code{new()}}{
Create a Filter object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$new(
  id,
  task_types,
  task_properties = character(),
  param_set = ps(),
  feature_types = character(),
  packages = character(),
  label = NA_character_,
  man = NA_character_
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{id}}{(\code{character(1)})\cr
Identifier for the filter.}

\item{\code{task_types}}{(\code{character()})\cr
Types of the task the filter can operator on. E.g., \code{"classif"} or
\code{"regr"}. Can be set to scalar \code{NA} to allow any task type.}

\item{\code{task_properties}}{(\code{character()})\cr
Required task properties, see \link[mlr3:Task]{mlr3::Task}.
Must be a subset of
\code{\link[mlr3:mlr_reflections]{mlr_reflections$task_properties}}.}

\item{\code{param_set}}{(\link[paradox:ParamSet]{paradox::ParamSet})\cr
Set of hyperparameters.}

\item{\code{feature_types}}{(\code{character()})\cr
Feature types the filter operates on.
Must be a subset of
\code{\link[mlr3:mlr_reflections]{mlr_reflections$task_feature_types}}.}

\item{\code{packages}}{(\code{character()})\cr
Set of required packages.
Note that these packages will be loaded via \code{\link[=requireNamespace]{requireNamespace()}}, and
are not attached.}

\item{\code{label}}{(\code{character(1)})\cr
Label for the new instance.}

\item{\code{man}}{(\code{character(1)})\cr
String in the format \verb{[pkg]::[topic]} pointing to a manual page for
this object. The referenced help package can be opened via method
\verb{$help()}.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-format"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-format}{}}}
\subsection{Method \code{format()}}{
Format helper for Filter class
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$format(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{(ignored).}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-print"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-print}{}}}
\subsection{Method \code{print()}}{
Printer for Filter class
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$print()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-help"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-help}{}}}
\subsection{Method \code{help()}}{
Opens the corresponding help page referenced by field \verb{$man}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$help()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-calculate"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-calculate}{}}}
\subsection{Method \code{calculate()}}{
Calculates the filter score values for the provided \link[mlr3:Task]{mlr3::Task} and
stores them in field \code{scores}. \code{nfeat} determines the minimum number of
features to score (see details), and defaults to the number
of features in \code{task}. Loads required packages and then calls
\code{private$.calculate()} of the respective subclass.

This private method is is expected to return a numeric vector, uniquely named
with (a subset of) feature names. The returned vector may have missing
values.
Features with missing values as well as features with no calculated
score are automatically ranked last, in a random order.
If the task has no rows, each feature gets the score \code{NA}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$calculate(task, nfeat = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{task}}{(\link[mlr3:Task]{mlr3::Task})\cr
\link[mlr3:Task]{mlr3::Task} to calculate the filter scores for.}

\item{\code{nfeat}}{(\code{\link[=integer]{integer()}})\cr
The minimum number of features to calculate filter scores for.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Filter-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Filter-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Filter$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
