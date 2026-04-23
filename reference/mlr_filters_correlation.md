# Correlation Filter

Simple correlation filter calling
[`stats::cor()`](https://rdrr.io/r/stats/cor.html). The filter score is
the absolute value of the correlation.

## Note

This filter, in its default settings, can handle missing values in the
features. However, the resulting filter scores may be misleading or at
least difficult to compare if some features have a large proportion of
missing values.

If a feature has no non-missing value, the resulting score will be `NA`.
Missing scores appear in a random, non-deterministic order at the end of
the vector of scores.

## References

For a benchmark of filter methods:

Bommert A, Sun X, Bischl B, Rahnenführer J, Lang M (2020). “Benchmark
for filter methods for feature selection in high-dimensional
classification data.” *Computational Statistics & Data Analysis*,
**143**, 106839.
[doi:10.1016/j.csda.2019.106839](https://doi.org/10.1016/j.csda.2019.106839)
.

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
[`mlr_filters_disr`](https://mlr3filters.mlr-org.com/reference/mlr_filters_disr.md),
[`mlr_filters_find_correlation`](https://mlr3filters.mlr-org.com/reference/mlr_filters_find_correlation.md),
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
-\> `FilterCorrelation`

## Methods

### Public methods

- [`FilterCorrelation$new()`](#method-FilterCorrelation-new)

- [`FilterCorrelation$clone()`](#method-FilterCorrelation-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterCorrelation object.

#### Usage

    FilterCorrelation$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterCorrelation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
## Pearson (default)
task = mlr3::tsk("mtcars")
filter = flt("correlation")
filter$calculate(task)
as.data.table(filter)
#>     feature     score
#>      <char>     <num>
#>  1:      wt 0.8676594
#>  2:     cyl 0.8521620
#>  3:    disp 0.8475514
#>  4:      hp 0.7761684
#>  5:    drat 0.6811719
#>  6:      vs 0.6640389
#>  7:      am 0.5998324
#>  8:    carb 0.5509251
#>  9:    gear 0.4802848
#> 10:    qsec 0.4186840

## Spearman
filter = FilterCorrelation$new()
filter$param_set$values = list("method" = "spearman")
filter$calculate(task)
as.data.table(filter)
#>     feature     score
#>      <char>     <num>
#>  1:     cyl 0.9108013
#>  2:    disp 0.9088824
#>  3:      hp 0.8946646
#>  4:      wt 0.8864220
#>  5:      vs 0.7065968
#>  6:    carb 0.6574976
#>  7:    drat 0.6514555
#>  8:      am 0.5620057
#>  9:    gear 0.5427816
#> 10:    qsec 0.4669358
if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("mtcars")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("correlation"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("regr.rpart"))

  graph$train(task)
}
#> $regr.rpart.output
#> NULL
#> 
```
