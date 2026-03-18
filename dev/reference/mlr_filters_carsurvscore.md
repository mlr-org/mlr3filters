# Correlation-Adjusted Survival Score Filter

Calculates CARS scores for right-censored survival tasks. Calls the
implementation in
[`carSurv::carSurvScore()`](https://rdrr.io/pkg/carSurv/man/carSurvScore.html)
in package [carSurv](https://CRAN.R-project.org/package=carSurv).

## References

Bommert A, Welchowski T, Schmid M, Rahnenführer J (2021). “Benchmark of
filter methods for feature selection in high-dimensional gene expression
survival data.” *Briefings in Bioinformatics*, **23**(1).
[doi:10.1093/bib/bbab354](https://doi.org/10.1093/bib/bbab354) .

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
[`mlr_filters_cmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_cmim.md),
[`mlr_filters_correlation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_correlation.md),
[`mlr_filters_disr`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_disr.md),
[`mlr_filters_find_correlation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_find_correlation.md),
[`mlr_filters_importance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_importance.md),
[`mlr_filters_information_gain`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_information_gain.md),
[`mlr_filters_jmi`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_jmi.md),
[`mlr_filters_jmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_jmim.md),
[`mlr_filters_kruskal_test`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_kruskal_test.md),
[`mlr_filters_mim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_mim.md),
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
-\> `FilterCarSurvScore`

## Methods

### Public methods

- [`FilterCarSurvScore$new()`](#method-FilterCarSurvScore-new)

- [`FilterCarSurvScore$clone()`](#method-FilterCarSurvScore-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterCarSurvScore object.

#### Usage

    FilterCarSurvScore$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterCarSurvScore$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
