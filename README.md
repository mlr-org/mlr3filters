
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

task = tsk("pima")
filter = flt("auc")
as.data.table(filter$calculate(task))
```

    ##     feature     score
    ## 1:  glucose 0.2927906
    ## 2:  insulin 0.2316288
    ## 3:     mass 0.1870358
    ## 4:      age 0.1869403
    ## 5:  triceps 0.1625115
    ## 6: pregnant 0.1195149
    ## 7: pressure 0.1075760
    ## 8: pedigree 0.1062015

### Implemented Filters

| Name              | Task Type      | Feature Types                              | Package                                                           |
|:------------------|:---------------|:-------------------------------------------|:------------------------------------------------------------------|
| anova             | Classif        | Integer, Numeric                           | stats                                                             |
| auc               | Classif        | Integer, Numeric                           | [mlr3measures](https://cran.r-project.org/package=mlr3measures)   |
| carscore          | Regr           | Numeric                                    | [care](https://cran.r-project.org/package=care)                   |
| cmim              | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| correlation       | Regr           | Integer, Numeric                           | stats                                                             |
| disr              | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| find_correlation  | Classif & Regr | Integer, Numeric                           | stats                                                             |
| importance        | Universal      | Logical, Integer, Numeric, Factor, Ordered |                                                                   |
| information_gain  | Classif & Regr | Integer, Numeric, Factor, Ordered          | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp) |
| jmi               | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| jmim              | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| kruskal_test      | Classif        | Integer, Numeric                           | stats                                                             |
| mim               | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| mrmr              | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| njmim             | Classif & Regr | Integer, Numeric, Factor, Ordered          | [praznik](https://cran.r-project.org/package=praznik)             |
| performance       | Universal      | Logical, Integer, Numeric, Factor, Ordered |                                                                   |
| permutation       | Universal      | Logical, Integer, Numeric, Factor, Ordered |                                                                   |
| relief            | Classif & Regr | Integer, Numeric, Factor, Ordered          | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp) |
| selected_features | Classif        | Logical, Integer, Numeric, Factor, Ordered |                                                                   |
| variance          | Classif & Regr | Integer, Numeric                           | stats                                                             |

### Variable Importance Filters

The following learners allow the extraction of variable importance and
therefore are supported by `FilterImportance`:

    ##  [1] "classif.featureless" "classif.ranger"      "classif.rpart"      
    ##  [4] "classif.xgboost"     "regr.featureless"    "regr.ranger"        
    ##  [7] "regr.rpart"          "regr.xgboost"        "surv.ranger"        
    ## [10] "surv.xgboost"

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

    ##         feature    score
    ## 1:  Petal.Width 43.66496
    ## 2: Petal.Length 43.10837
    ## 3: Sepal.Length 10.21944

### Performance Filter

`FilterPerformance` is a univariate filter method which calls
`resample()` with every predictor variable in the dataset and ranks the
final outcome using the supplied measure. Any learner can be passed to
this filter with `classif.rpart` being the default. Of course, also
regression learners can be passed if the task is of type “regr”.
