# Correlation-Adjusted Marignal Correlation Score Filter

Calculates the Correlation-Adjusted (marginal) coRrelation scores (short
CAR scores) implemented in
[`care::carscore()`](https://rdrr.io/pkg/care/man/carscore.html) in
package [care](https://CRAN.R-project.org/package=care). The CAR scores
for a set of features are defined as the correlations between the target
and the decorrelated features. The filter returns the absolute value of
the calculated scores.

Argument `verbose` defaults to `FALSE`.

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
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/reference/mlr_filters_variance.md)

## Super class

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/reference/Filter.md)
-\> `FilterCarScore`

## Methods

### Public methods

- [`FilterCarScore$new()`](#method-FilterCarScore-new)

- [`FilterCarScore$clone()`](#method-FilterCarScore-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterCarScore object.

#### Usage

    FilterCarScore$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterCarScore$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("care")) {
  task = mlr3::tsk("mtcars")
  filter = flt("carscore")
  filter$calculate(task)
  head(as.data.table(filter), 3)

  ## changing the filter settings
  filter = flt("carscore")
  filter$param_set$values = list("diagonal" = TRUE)
  filter$calculate(task)
  head(as.data.table(filter), 3)
}
#> Estimating optimal shrinkage intensity lambda (correlation matrix): 0.0707 
#>    feature     score
#>     <char>     <num>
#> 1:      wt 0.8062818
#> 2:     cyl 0.7918806
#> 3:    disp 0.7875962

if (mlr3misc::require_namespaces(c("mlr3pipelines", "care", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("mtcars")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("carscore"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("regr.rpart"))

  graph$train(task)
}
#> $regr.rpart.output
#> NULL
#> 
```
