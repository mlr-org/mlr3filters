
# mlr3filters

Package website: [release](https://mlr3filters.mlr-org.com/) |
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

task = tsk("pima")
filter = flt("auc")
as.data.table(filter$calculate(task))
```

    ##     feature     score
    ##      <char>     <num>
    ## 1:  glucose 0.2927906
    ## 2:  insulin 0.2316288
    ## 3:     mass 0.1870358
    ## 4:      age 0.1869403
    ## 5:  triceps 0.1625115
    ## 6: pregnant 0.1195149
    ## 7: pressure 0.1075760
    ## 8: pedigree 0.1062015

### Implemented Filters

    ## Warning in `[.data.table`(as.data.table(mlr_filters), , !c("param_set", :
    ## column(s) not removed because not found: [param_set]

| Name               | label                                                    | Task Type      | params                               | Feature Types                                                  | Package                                                                                                                                   |
| :----------------- | :------------------------------------------------------- | :------------- | :----------------------------------- | :------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| anova              | ANOVA F-Test                                             | Classif        |                                      | Integer, Numeric                                               | [c(“mlr3filters”, “stats”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22stats%22\))                                     |
| auc                | Area Under the ROC Curve Score                           | Classif        |                                      | Integer, Numeric                                               | [c(“mlr3filters”, “mlr3measures”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22mlr3measures%22\))                       |
| carsurvscore       | Correlation-Adjusted coRrelation Survival Score          | Surv           | maxIPCweight, denom                  | Integer, Numeric                                               | [c(“mlr3filters”, “carSurv”, “mlr3proba”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22carSurv%22,%20%22mlr3proba%22\)) |
| cmim               | Minimal Conditional Mutual Information Maximization      | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| correlation        | Correlation                                              | Regr           | use , method                         | Integer, Numeric                                               | [c(“mlr3filters”, “stats”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22stats%22\))                                     |
| disr               | Double Input Symmetrical Relevance                       | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| find\_correlation  | Correlation-based Score                                  | Classif & Regr | use , method                         | Integer, Numeric                                               | [c(“mlr3filters”, “stats”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22stats%22\))                                     |
| importance         | Importance Score                                         | Universal      | method                               | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                                           |
| information\_gain  | Information Gain                                         | Classif & Regr | type , equal , discIntegers, threads | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “FSelectorRcpp”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22FSelectorRcpp%22\))                     |
| jmi                | Joint Mutual Information                                 | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| jmim               | Minimal Joint Mutual Information Maximization            | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| kruskal\_test      | Kruskal-Wallis Test                                      | Classif        | na.action                            | Integer, Numeric                                               | [c(“mlr3filters”, “stats”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22stats%22\))                                     |
| mim                | Mutual Information Maximization                          | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| mrmr               | Minimum Redundancy Maximal Relevancy                     | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| njmim              | Minimal Normalised Joint Mutual Information Maximization | Classif & Regr | threads                              | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “praznik”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22praznik%22\))                                 |
| performance        | Predictive Performance                                   | Universal      | method                               | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                                           |
| permutation        | Permutation Score                                        | Universal      | standardize, nmc                     | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                                           |
| relief             | RELIEF                                                   | Classif & Regr | neighboursCount, sampleSize          | Integer, Numeric, Factor, Ordered                              | [c(“mlr3filters”, “FSelectorRcpp”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22FSelectorRcpp%22\))                     |
| selected\_features | Embedded Feature Selection                               | Classif        | method                               | Logical, Integer, Numeric, Character, Factor, Ordered, POSIXct |                                                                                                                                           |
| variance           | Variance                                                 | NA             | na.rm                                | Integer, Numeric                                               | [c(“mlr3filters”, “stats”)](https://cran.r-project.org/package=c\(%22mlr3filters%22,%20%22stats%22\))                                     |

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
    ##          <char>     <num>
    ## 1:  Petal.Width 44.224198
    ## 2: Petal.Length 43.303520
    ## 3: Sepal.Length  9.618601

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

# the filter.frac should be tuned
graph = po("filter", filter = flt("auc"), filter.frac = 0.5) %>>%
  po("learner", lrn("classif.rpart"))

learner = as_learner(graph)
rr = resample(task, learner, rsmp("holdout"))
```

    ## INFO  [13:42:32.254] [mlr3] Applying learner 'auc.classif.rpart' on task 'spam' (iter 1/1)
