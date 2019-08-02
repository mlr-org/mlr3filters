
# mlr3filters

*mlr3filters* adds filters, feature selection methods and embedded
feature selection methods of algorithms to *mlr3*.

[![Travis build
status](https://travis-ci.org/mlr-org/mlr3filters.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3filters)
[![CRAN
status](https://www.r-pkg.org/badges/version/mlr3filters)](https://cran.r-project.org/package=mlr3filters)
[![Coverage
status](https://codecov.io/gh/mlr-org/mlr3filters/branch/master/graph/badge.svg)](https://codecov.io/github/mlr-org/mlr3filters?branch=master)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

## Installation

``` r
remotes::install_github("mlr-org/mlr3filters")
```

## Filters

### Filter Example

``` r
library("mlr3")
library("mlr3filters")

task = mlr_tasks$get("pima")
filter = mlr_filters$get("auc")
as.data.table(filter$calculate(task))
```

    ##     feature      score
    ##      <char>      <num>
    ## 1:  glucose 0.28961567
    ## 2:      age 0.18694030
    ## 3:     mass 0.17702985
    ## 4: pregnant 0.11951493
    ## 5: pressure 0.10810075
    ## 6: pedigree 0.10620149
    ## 7:  triceps 0.10125373
    ## 8:  insulin 0.07975746

### Implemented Filters

| Name                     | Task Type      | Feature Types                                         | Package                                                           |
| :----------------------- | :------------- | :---------------------------------------------------- | :---------------------------------------------------------------- |
| anova                    | Classif        | Integer, Numeric                                      | stats                                                             |
| auc                      | Classif        | Integer, Numeric                                      | [Metrics](https://cran.r-project.org/package=Metrics)             |
| carscore                 | Regr           | Numeric                                               | [care](https://cran.r-project.org/package=care)                   |
| cmim                     | Classif & Regr | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| correlation              | Regr           | Integer, Numeric                                      | stats                                                             |
| disr                     | Classif        | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| gain\_ratio              | Classif & Regr | Integer, Numeric, Factor, Ordered                     | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp) |
| importance               | Classif        | Logical, Integer, Numeric, Character, Factor, Ordered | [rpart](https://cran.r-project.org/package=rpart)                 |
| information\_gain        | Classif & Regr | Integer, Numeric, Factor, Ordered                     | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp) |
| jmi                      | Classif        | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| jmim                     | Classif        | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| kruskal\_test            | Classif        | Integer, Numeric                                      | stats                                                             |
| mim                      | Classif        | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| mrmr                     | Classif & Regr | Numeric, Factor, Integer, Character, Logical          | [praznik](https://cran.r-project.org/package=praznik)             |
| njmim                    | Classif        | Integer, Numeric, Factor, Ordered                     | [praznik](https://cran.r-project.org/package=praznik)             |
| performance              | Classif        | Logical, Integer, Numeric, Character, Factor, Ordered | [rpart](https://cran.r-project.org/package=rpart)                 |
| symmetrical\_uncertainty | Classif & Regr | Integer, Numeric, Factor, Ordered                     | [FSelectorRcpp](https://cran.r-project.org/package=FSelectorRcpp) |
| variance                 | Classif & Regr | Integer, Numeric                                      | stats                                                             |

### Variable Importance Filters

The following learners allow the extraction of variable importance and
therefore are supported by `FilterImportance`:

    ## [1] "classif.featureless" "classif.ranger"      "classif.rpart"
    ## [4] "classif.xgboost"     "regr.featureless"    "regr.ranger"
    ## [7] "regr.rpart"          "regr.xgboost"

If your learner is listed here, the reason is most likely that it is not
integrated into [mlr3learners](https://github.com/mlr-org/mlr3learners)
or [mlr3extralearners](https://github.com/mlr-org/mlr3extralearners).
Please open an issue so we can add your package.

Some learners need to have their variable importance measure “activated”
during learner creation. For example, to use the “impurity” measure of
Random Forest via the *ranger* package:

``` r
task = mlr_tasks$get("iris")
lrn = mlr_learners$get("classif.ranger",
  param_vals = list(importance = "impurity"))

filter = FilterImportance$new(learner = lrn)
filter$calculate(task)
head(as.data.table(filter), 3)
```

    ##         feature     score
    ##          <char>     <num>
    ## 1:  Petal.Width 45.977676
    ## 2: Petal.Length 41.064991
    ## 3: Sepal.Length  9.733556

### Performance Filter

`FilterPerformance` is a univariate filter method which calls
`resample()` with every predictor variable in the dataset and ranks the
final outcome using the supplied measure. Any learner can be passed to
this filter with `classif.rpart` being the default.
