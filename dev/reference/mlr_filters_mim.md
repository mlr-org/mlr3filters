# Mutual Information Maximization Filter

Conditional mutual information based feature selection filter calling
[`praznik::MIM()`](https://rdrr.io/pkg/praznik/man/MIM.html) in package
[praznik](https://CRAN.R-project.org/package=praznik).

This filter supports partial scoring (see
[Filter](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)).

## Details

As the scores calculated by the
[praznik](https://CRAN.R-project.org/package=praznik) package are not
monotone due to the greedy forward fashion, the returned scores simply
reflect the selection order: `1`, `(k-1)/k`, ..., `1/k` where `k` is the
number of selected features.

Threading is disabled by default (hyperparameter `threads` is set to 1).
Set to a number `>= 2` to enable threading, or to `0` for auto-detecting
the number of available cores.

## References

Kursa MB (2021). “Praznik: High performance information-based feature
selection.” *SoftwareX*, **16**, 100819.
[doi:10.1016/j.softx.2021.100819](https://doi.org/10.1016/j.softx.2021.100819)
.

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
  of [Filters](https://mlr3filters.mlr-org.com/dev/reference/Filter.md):
  [mlr_filters](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters.md)

Other Filter:
[`Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md),
[`mlr_filters`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters.md),
[`mlr_filters_anova`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_anova.md),
[`mlr_filters_auc`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_auc.md),
[`mlr_filters_boruta`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_boruta.md),
[`mlr_filters_carscore`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_carscore.md),
[`mlr_filters_carsurvscore`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_carsurvscore.md),
[`mlr_filters_cmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_cmim.md),
[`mlr_filters_correlation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_correlation.md),
[`mlr_filters_disr`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_disr.md),
[`mlr_filters_find_correlation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_find_correlation.md),
[`mlr_filters_importance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_importance.md),
[`mlr_filters_information_gain`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_information_gain.md),
[`mlr_filters_jmi`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_jmi.md),
[`mlr_filters_jmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_jmim.md),
[`mlr_filters_kruskal_test`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_kruskal_test.md),
[`mlr_filters_mrmr`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_mrmr.md),
[`mlr_filters_njmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_njmim.md),
[`mlr_filters_performance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_performance.md),
[`mlr_filters_permutation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_permutation.md),
[`mlr_filters_relief`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_relief.md),
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Super class

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)
-\> `FilterMIM`

## Methods

### Public methods

- [`FilterMIM$new()`](#method-FilterMIM-new)

- [`FilterMIM$clone()`](#method-FilterMIM-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterMIM object.

#### Usage

    FilterMIM$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterMIM$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("praznik")) {
  task = mlr3::tsk("iris")
  filter = flt("mim")
  filter$calculate(task, nfeat = 2)
  as.data.table(filter)
}
#>         feature score
#>          <char> <num>
#> 1:  Petal.Width     1
#> 2: Petal.Length     0
#> 3:  Sepal.Width    NA
#> 4: Sepal.Length    NA

if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart", "praznik"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("spam")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("mim"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)
}
#> $classif.rpart.output
#> NULL
#> 
```
