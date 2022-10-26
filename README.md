
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

[![tic](https://github.com/mlr-org/mlr3filters/workflows/tic/badge.svg?branch=master)](https://github.com/mlr-org/mlr3filters/actions)
[![CRAN
Status](https://www.r-pkg.org/badges/version/mlr3filters)](https://cran.r-project.org/package=mlr3filters)
[![CodeFactor](https://www.codefactor.io/repository/github/mlr-org/mlr3filters/badge)](https://www.codefactor.io/repository/github/mlr-org/mlr3filters)
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
as.data.table(filter$calculate(task))
```

    ##     feature       score
    ##  1:     V11 0.281136807
    ##  2:     V12 0.242918176
    ##  3:     V10 0.232701774
    ##  4:     V49 0.231262190
    ##  5:      V9 0.230844246
    ##  6:     V48 0.206278443
    ##  7:     V13 0.204699545
    ##  8:     V51 0.199359153
    ##  9:     V47 0.197408749
    ## 10:     V52 0.188028234
    ## 11:     V46 0.187053032
    ## 12:     V45 0.172703631
    ## 13:      V4 0.165227083
    ## 14:     V36 0.165180645
    ## 15:      V5 0.153710411
    ## 16:      V1 0.152317266
    ## 17:     V44 0.151063435
    ## 18:     V21 0.144469211
    ## 19:     V35 0.141450729
    ## 20:      V8 0.141032785
    ## 21:     V43 0.140893471
    ## 22:     V37 0.128076530
    ## 23:      V6 0.124640104
    ## 24:     V20 0.123572026
    ## 25:      V2 0.122782576
    ## 26:     V50 0.121807374
    ## 27:      V3 0.116513421
    ## 28:     V14 0.114748769
    ## 29:     V22 0.113680691
    ## 30:     V58 0.098402526
    ## 31:     V42 0.091436798
    ## 32:     V34 0.090275843
    ## 33:     V23 0.085632024
    ## 34:      V7 0.085074765
    ## 35:     V28 0.078944924
    ## 36:     V31 0.078341228
    ## 37:     V19 0.077366026
    ## 38:     V53 0.071607690
    ## 39:     V54 0.068031949
    ## 40:     V56 0.060648277
    ## 41:     V39 0.058094177
    ## 42:     V33 0.056793907
    ## 43:     V24 0.055447200
    ## 44:     V59 0.054611312
    ## 45:     V27 0.053543234
    ## 46:     V15 0.053264605
    ## 47:     V32 0.043187517
    ## 48:     V16 0.031485093
    ## 49:     V29 0.028605926
    ## 50:     V17 0.026516207
    ## 51:     V41 0.024472927
    ## 52:     V18 0.018621714
    ## 53:     V26 0.017507198
    ## 54:     V38 0.014813783
    ## 55:     V25 0.013838581
    ## 56:     V60 0.012213244
    ## 57:     V30 0.006965729
    ## 58:     V57 0.004876010
    ## 59:     V55 0.003204235
    ## 60:     V40 0.002182595
    ##     feature       score

### Implemented Filters

| Name              | label                                                    | Task Types     | Feature Types                                                  | Package                                                                                                          |
|:------------------|:---------------------------------------------------------|:---------------|:---------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| anova             | ANOVA F-Test                                             | Classif        | Integer, Numeric                                               | stats                                                                                                            |
| auc               | Area Under the ROC Curve Score                           | Classif        | Integer, Numeric                                               | [mlr3measures](https://cran.r-project.org/package=mlr3measures)                                                  |
| carscore          | Correlation-Adjusted coRrelation Score                   | Regr           | Numeric                                                        | [care](https://cran.r-project.org/package=care)                                                                  |
| carsurvscore      | Correlation-Adjusted coRrelation Survival Score          | Surv           | Integer, Numeric                                               | [carSurv](https://cran.r-project.org/package=carSurv), [mlr3proba](https://cran.r-project.org/package=mlr3proba) |
| cmim              | Minimal Conditional Mutual Information Maximization      | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| correlation       | Correlation                                              | Regr           | Integer, Numeric                                               | stats                                                                                                            |
| disr              | Double Input Symmetrical Relevance                       | Classif & Regr | Integer, Numeric, Factor, Ordered                              | [praznik](https://cran.r-project.org/package=praznik)                                                            |
| find_correlation  | Correlation-based Score                                  | Classif & Regr | Integer, Numeric                                               | stats                                                                                                            |
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
lrn = lrn("classif.ranger")
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
