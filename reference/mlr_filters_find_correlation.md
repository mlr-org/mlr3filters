# Correlation Filter

Simple filter emulating `caret::findCorrelation(exact = FALSE)`.

This gives each feature a score between 0 and 1 that is *one minus* the
cutoff value for which it is excluded when using
[`caret::findCorrelation()`](https://rdrr.io/pkg/caret/man/findCorrelation.html).
The negative is used because
[`caret::findCorrelation()`](https://rdrr.io/pkg/caret/man/findCorrelation.html)
excludes everything *above* a cutoff, while filters exclude everything
below a cutoff. Here the filter scores are shifted by +1 to get positive
values for to align with the way other filters work.

Subsequently `caret::findCorrelation(cutoff = 0.9)` lists the same
features that are excluded with `FilterFindCorrelation` at score 0.1 (=
1 - 0.9).

## See also

- [PipeOpFilter](https://mlr3pipelines.mlr-org.com/reference/mlr_pipeops_filter.html)
  for filter-based feature selection.

- [Dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
  of [Filters](https://mlr3filters.mlr-org.com/reference/Filter.md):
  [mlr_filters](https://mlr3filters.mlr-org.com/reference/mlr_filters.md)

Other Filter:
[`Filter`](https://mlr3filters.mlr-org.com/reference/Filter.md),
[`mlr_filters`](https://mlr3filters.mlr-org.com/reference/mlr_filters.md),
[`mlr_filters_anova`](https://mlr3filters.mlr-org.com/reference/mlr_filters_anova.md),
[`mlr_filters_auc`](https://mlr3filters.mlr-org.com/reference/mlr_filters_auc.md),
[`mlr_filters_boruta`](https://mlr3filters.mlr-org.com/reference/mlr_filters_boruta.md),
[`mlr_filters_carscore`](https://mlr3filters.mlr-org.com/reference/mlr_filters_carscore.md),
[`mlr_filters_carsurvscore`](https://mlr3filters.mlr-org.com/reference/mlr_filters_carsurvscore.md),
[`mlr_filters_cmim`](https://mlr3filters.mlr-org.com/reference/mlr_filters_cmim.md),
[`mlr_filters_correlation`](https://mlr3filters.mlr-org.com/reference/mlr_filters_correlation.md),
[`mlr_filters_disr`](https://mlr3filters.mlr-org.com/reference/mlr_filters_disr.md),
[`mlr_filters_importance`](https://mlr3filters.mlr-org.com/reference/mlr_filters_importance.md),
[`mlr_filters_information_gain`](https://mlr3filters.mlr-org.com/reference/mlr_filters_information_gain.md),
[`mlr_filters_jmi`](https://mlr3filters.mlr-org.com/reference/mlr_filters_jmi.md),
[`mlr_filters_jmim`](https://mlr3filters.mlr-org.com/reference/mlr_filters_jmim.md),
[`mlr_filters_kruskal_test`](https://mlr3filters.mlr-org.com/reference/mlr_filters_kruskal_test.md),
[`mlr_filters_mim`](https://mlr3filters.mlr-org.com/reference/mlr_filters_mim.md),
[`mlr_filters_mrmr`](https://mlr3filters.mlr-org.com/reference/mlr_filters_mrmr.md),
[`mlr_filters_njmim`](https://mlr3filters.mlr-org.com/reference/mlr_filters_njmim.md),
[`mlr_filters_performance`](https://mlr3filters.mlr-org.com/reference/mlr_filters_performance.md),
[`mlr_filters_permutation`](https://mlr3filters.mlr-org.com/reference/mlr_filters_permutation.md),
[`mlr_filters_relief`](https://mlr3filters.mlr-org.com/reference/mlr_filters_relief.md),
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/reference/mlr_filters_variance.md)

## Super class

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/reference/Filter.md)
-\> `FilterFindCorrelation`

## Methods

### Public methods

- [`FilterFindCorrelation$new()`](#method-FilterFindCorrelation-new)

- [`FilterFindCorrelation$clone()`](#method-FilterFindCorrelation-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterFindCorrelation object.

#### Usage

    FilterFindCorrelation$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterFindCorrelation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Pearson (default)
task = mlr3::tsk("mtcars")
filter = flt("find_correlation")
filter$calculate(task)
as.data.table(filter)
#>     feature      score
#>      <char>      <num>
#>  1:    carb 1.00000000
#>  2:    gear 0.72592716
#>  3:    qsec 0.34375077
#>  4:      wt 0.28755935
#>  5:    drat 0.28728887
#>  6:      vs 0.25546456
#>  7:      hp 0.25018753
#>  8:      am 0.20594124
#>  9:    disp 0.11202008
#> 10:     cyl 0.09796713

## Spearman
filter = flt("find_correlation", method = "spearman")
filter$calculate(task)
as.data.table(filter)
#>     feature      score
#>      <char>      <num>
#>  1:    qsec 1.00000000
#>  2:      am 0.79666789
#>  3:    carb 0.34128186
#>  4:    drat 0.25518383
#>  5:      hp 0.24840661
#>  6:      wt 0.22532327
#>  7:      vs 0.20842852
#>  8:    gear 0.19231200
#>  9:    disp 0.10229356
#> 10:     cyl 0.07234842

if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("spam")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("find_correlation"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)
}
#> $classif.rpart.output
#> NULL
#> 
```
