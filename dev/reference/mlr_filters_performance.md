# Predictive Performance Filter

Filter which uses the predictive performance of a
[mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html) as
filter score. Performs a
[`mlr3::resample()`](https://mlr3.mlr-org.com/reference/resample.html)
for each feature separately. The filter score is the aggregated
performance of the
[mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html), or the
negated aggregated performance if the measure has to be minimized.

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
[`mlr_filters_mim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_mim.md),
[`mlr_filters_mrmr`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_mrmr.md),
[`mlr_filters_njmim`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_njmim.md),
[`mlr_filters_permutation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_permutation.md),
[`mlr_filters_relief`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_relief.md),
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Super classes

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)
-\> `mlr3filters::FilterLearner` -\> `FilterPerformance`

## Public fields

- `learner`:

  ([mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html))  

- `resampling`:

  ([mlr3::Resampling](https://mlr3.mlr-org.com/reference/Resampling.html))  

- `measure`:

  ([mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html))  

## Methods

### Public methods

- [`FilterPerformance$new()`](#method-FilterPerformance-new)

- [`FilterPerformance$clone()`](#method-FilterPerformance-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterDISR object.

#### Usage

    FilterPerformance$new(
      learner = mlr3::lrn("classif.featureless"),
      resampling = mlr3::rsmp("holdout"),
      measure = NULL
    )

#### Arguments

- `learner`:

  ([mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html))  
  [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html) to
  use for model fitting.

- `resampling`:

  ([mlr3::Resampling](https://mlr3.mlr-org.com/reference/Resampling.html))  
  [mlr3::Resampling](https://mlr3.mlr-org.com/reference/Resampling.html)
  to be used within resampling.

- `measure`:

  ([mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html))  
  [mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html) to be
  used for evaluating the performance.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterPerformance$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("rpart")) {
  task = mlr3::tsk("iris")
  learner = mlr3::lrn("classif.rpart")
  filter = flt("performance", learner = learner)
  filter$calculate(task)
  as.data.table(filter)
}
#>         feature score
#>          <char> <num>
#> 1:  Petal.Width  0.00
#> 2: Petal.Length -0.08
#> 3: Sepal.Length -0.28
#> 4:  Sepal.Width -0.44

if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("iris")
  l = lrn("classif.rpart")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("performance", learner = l), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)
}
#> $classif.rpart.output
#> NULL
#> 
```
