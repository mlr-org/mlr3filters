
# mlr3filters

Package website: [release](https://mlr3filters.mlr-org.com/) \|
[dev](https://mlr3filters.mlr-org.com/dev/)

{mlr3filters} adds feature selection filters to
[mlr3](https://mlr3.mlr-org.com). The implemented filters can be used
stand-alone, or as part of a machine learning pipeline in combination
with [mlr3pipelines](https://mlr3pipelines.mlr-org.com) and the [filter
operator](https://mlr3pipelines.mlr-org.com/reference/mlr_pipeops_filter.html).

Wrapper methods for feature selection are implemented in
[mlr3fselect](https://mlr3fselect.mlr-org.com). Learners which support
the extraction feature importance scores can be combined with a filter
from this package for embedded feature selection.

<!-- badges: start -->

[![r-cmd-check](https://github.com/mlr-org/mlr3filters/actions/workflows/r-cmd-check.yml/badge.svg)](https://github.com/mlr-org/mlr3filters/actions/workflows/r-cmd-check.yml)
[![CRAN
Status](https://www.r-pkg.org/badges/version-ago/mlr3filters)](https://cran.r-project.org/package=mlr3filters)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)
[![Mattermost](https://img.shields.io/badge/chat-mattermost-orange.svg)](https://lmmisld-lmu-stats-slds.srv.mwn.de/mlr_invite/)
<!-- badges: end -->

## Installation

CRAN version

``` r
install.packages("mlr3filters")
```

Development version

``` r
remotes::install_github("mlr-org/mlr3filters")
```

## Filters

### Filter Example

``` r
set.seed(1)
library("mlr3")
library("mlr3filters")

task = tsk("sonar")
filter = flt("auc")
head(as.data.table(filter$calculate(task)))
```

    ##    feature     score
    ## 1:     V11 0.2811368
    ## 2:     V12 0.2429182
    ## 3:     V10 0.2327018
    ## 4:     V49 0.2312622
    ## 5:      V9 0.2308442
    ## 6:     V48 0.2062784

### Implemented Filters

| Name              | label                                                    | Task Types     | Feature Types                                                  | Package                                                                                                          |
|:------------------|:---------------------------------------------------------|:---------------|:---------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| anova             | ANOVA F-Test                                             | Classif        | Integer, Numeric                                               | stats                                                                                                            |
| auc               | Area Under the ROC Curve Score                           | Classif        | Integer, Numeric                                               | [mlr3measures](https://cran.r-project.org/package=mlr3measures)                                                  |
| carscore          | Correlation-Adjusted coRrelation Score                   | Regr           | Logical, Integer, Numeric                                      | [care](https://cran.r-project.org/package=care)                                                                  |
| carsurvscore      | Correlation-Adjusted coRrelation Survival Score          | Surv           | Integer, Numeric                                               | [carSurv](https://cran.r-project.org/package=carSurv), [mlr3proba](https://cran.r-project.org/package=mlr3proba) |
| cmim              | Minimal Conditional Mutual Information Maximization      | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| correlation       | Correlation                                              | Regr           | Integer, Numeric                                               | stats                                                                                                            |
| disr              | Double Input Symmetrical Relevance                       | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| find_correlation  | Correlation-based Score                                  | Universal      | Integer, Numeric                                               | stats                                                                                                            |
| importance        | Importance Score                                         | Universal      | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                  |
| information_gain  | Information Gain                                         | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp)                                                |
| jmi               | Joint Mutual Information                                 | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| jmim              | Minimal Joint Mutual Information Maximization            | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| kruskal_test      | Kruskal-Wallis Test                                      | Classif        | Integer, Numeric                                               | stats                                                                                                            |
| mim               | Mutual Information Maximization                          | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| mrmr              | Minimum Redundancy Maximal Relevancy                     | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| njmim             | Minimal Normalised Joint Mutual Information Maximization | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| performance       | Predictive Performance                                   | Universal      | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                  |
| permutation       | Permutation Score                                        | Universal      | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                  |
| relief            | RELIEF                                                   | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp)                                                |
| selected_features | Embedded Feature Selection                               | Universal      | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                  |
| univariate_cox    | Univariate Cox Survival Score                            | Surv           | Integer, Numeric, Logical                                      | [survival](https://cran.r-project.org/package=survival)                                                          |
| variance          | Variance                                                 | Universal      | Integer, Numeric                                               | stats                                                                                                            |

### Variable Importance Filters

The following learners allow the extraction of variable importance and
therefore are supported by `FilterImportance`:

    ## [1] "classif.featureless" "classif.ranger"      "classif.rpart"      
    ## [4] "classif.xgboost"     "regr.featureless"    "regr.ranger"        
    ## [7] "regr.rpart"          "regr.xgboost"

If your learner is not listed here but capable of extracting variable
importance from the fitted model, the reason is most likely that it is
not yet integrated in the package
[mlr3learners](https://github.com/mlr-org/mlr3learners) or the [extra
learner organization](https://github.com/mlr3learners). Please open an
issue so we can add your package.

Some learners need to have their variable importance measure “activated”
during learner creation. For example, to use the “impurity” measure of
Random Forest via the {ranger} package:

``` r
task = tsk("iris")
lrn = lrn("classif.ranger", seed = 42)
lrn$param_set$values = list(importance = "impurity")

filter = flt("importance", learner = lrn)
filter$calculate(task)
head(as.data.table(filter), 3)
```

    ##         feature     score
    ## 1: Petal.Length 44.682462
    ## 2:  Petal.Width 43.113031
    ## 3: Sepal.Length  9.039099

### Performance Filter

`FilterPerformance` is a univariate filter method which calls
`resample()` with every predictor variable in the dataset and ranks the
final outcome using the supplied measure. Any learner can be passed to
this filter with `classif.rpart` being the default. Of course, also
regression learners can be passed if the task is of type “regr”.

### Filter-based Feature Selection

In many cases filtering is only one step in the modeling pipeline. To
select features based on filter values, one can use
[`PipeOpFilter`](https://mlr3pipelines.mlr-org.com/reference/mlr_pipeops_filter.html)
from [mlr3pipelines](https://github.com/mlr-org/mlr3pipelines).

``` r
library(mlr3pipelines)
task = tsk("spam")

# the `filter.frac` should be tuned
graph = po("filter", filter = flt("auc"), filter.frac = 0.5) %>>%
  po("learner", lrn("classif.rpart"))

learner = as_learner(graph)
rr = resample(task, learner, rsmp("holdout"))
```
