# Permutation Score Filter

The permutation filter randomly permutes the values of a single feature
in a [mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html) to break
the association with the response. The permuted feature, together with
the unmodified features, is used to perform a
[`mlr3::resample()`](https://mlr3.mlr-org.com/reference/resample.html).
The permutation filter score is the difference between the aggregated
performance of the
[mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html) and the
performance estimated on the unmodified
[mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html).

## Parameters

- `standardize`:

  `logical(1)`  
  Standardize feature importance by maximum score.

- `nmc`:

  `integer(1)`

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
[`mlr_filters_performance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_performance.md),
[`mlr_filters_relief`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_relief.md),
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Super classes

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)
-\> `mlr3filters::FilterLearner` -\> `FilterPermutation`

## Public fields

- `learner`:

  ([mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html))  

- `resampling`:

  ([mlr3::Resampling](https://mlr3.mlr-org.com/reference/Resampling.html))  

- `measure`:

  ([mlr3::Measure](https://mlr3.mlr-org.com/reference/Measure.html))  

## Active bindings

- `hash`:

  (`character(1)`)  
  Hash (unique identifier) for this object.

- `phash`:

  (`character(1)`)  
  Hash (unique identifier) for this partial object, excluding some
  components which are varied systematically during tuning (parameter
  values) or feature selection (feature names).

## Methods

### Public methods

- [`FilterPermutation$new()`](#method-FilterPermutation-new)

- [`FilterPermutation$clone()`](#method-FilterPermutation-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterPermutation object.

#### Usage

    FilterPermutation$new(
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

    FilterPermutation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("rpart")) {
  learner = mlr3::lrn("classif.rpart")
  resampling = mlr3::rsmp("holdout")
  measure = mlr3::msr("classif.acc")
  filter = flt("permutation", learner = learner, measure = measure, resampling = resampling,
    nmc = 2)
  task = mlr3::tsk("iris")
  filter$calculate(task)
  as.data.table(filter)
}
#>         feature score
#>          <char> <num>
#> 1: Sepal.Length  0.03
#> 2:  Sepal.Width  0.00
#> 3: Petal.Length -0.01
#> 4:  Petal.Width -0.02

if (mlr3misc::require_namespaces(c("mlr3pipelines", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("iris")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("permutation", nmc = 2), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)
}
#> $classif.rpart.output
#> NULL
#> 
```
