# Variance Filter

Variance filter calling
[`stats::var()`](https://rdrr.io/r/stats/cor.html).

Argument `na.rm` defaults to `TRUE` here.

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
[`mlr_filters_correlation`](https://mlr3filters.mlr-org.com/reference/mlr_filters_correlation.md),
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
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/reference/mlr_filters_univariate_cox.md)

## Super class

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/reference/Filter.md)
-\> `FilterVariance`

## Methods

### Public methods

- [`FilterVariance$new()`](#method-FilterVariance-new)

- [`FilterVariance$clone()`](#method-FilterVariance-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterVariance object.

#### Usage

    FilterVariance$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterVariance$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
task = mlr3::tsk("mtcars")
filter = flt("variance")
filter$calculate(task)
head(filter$scores, 3)
#>         disp           hp         qsec 
#> 15360.799829  4700.866935     3.193166 
as.data.table(filter)
#>     feature        score
#>      <char>        <num>
#>  1:    disp 1.536080e+04
#>  2:      hp 4.700867e+03
#>  3:    qsec 3.193166e+00
#>  4:     cyl 3.189516e+00
#>  5:    carb 2.608871e+00
#>  6:      wt 9.573790e-01
#>  7:    gear 5.443548e-01
#>  8:    drat 2.858814e-01
#>  9:      vs 2.540323e-01
#> 10:      am 2.489919e-01

if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("spam")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("variance"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)
}
#> $classif.rpart.output
#> NULL
#> 
```
