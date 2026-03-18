# Filter for Embedded Feature Selection

Filter using embedded feature selection of machine learning algorithms.
Takes a [mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html)
which is capable of extracting the selected features (property
"selected_features"), fits the model and extracts the selected features.

Note that contrary to
[mlr_filters_importance](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_importance.md),
there is no ordering in the selected features. Selected features get a
score of 1, deselected features get a score of 0. The order of selected
features is random and different from the order in the learner. In
combination with
[mlr3pipelines](https://CRAN.R-project.org/package=mlr3pipelines), only
the filter criterion `cutoff` makes sense.

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
[`mlr_filters_permutation`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_permutation.md),
[`mlr_filters_relief`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_relief.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Super classes

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)
-\> `mlr3filters::FilterLearner` -\> `FilterSelectedFeatures`

## Public fields

- `learner`:

  ([mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html))  
  Learner to extract the importance values from.

## Methods

### Public methods

- [`FilterSelectedFeatures$new()`](#method-FilterSelectedFeatures-new)

- [`FilterSelectedFeatures$clone()`](#method-FilterSelectedFeatures-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterImportance object.

#### Usage

    FilterSelectedFeatures$new(learner = mlr3::lrn("classif.featureless"))

#### Arguments

- `learner`:

  ([mlr3::Learner](https://mlr3.mlr-org.com/reference/Learner.html))  
  Learner to extract the selected features from.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterSelectedFeatures$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("rpart")) {
  task = mlr3::tsk("iris")
  learner = mlr3::lrn("classif.rpart")
  filter = flt("selected_features", learner = learner)
  filter$calculate(task)
  as.data.table(filter)
}
#>         feature score
#>          <char> <num>
#> 1:  Petal.Width     1
#> 2: Petal.Length     1
#> 3:  Sepal.Width     0
#> 4: Sepal.Length     0

if (mlr3misc::require_namespaces(c("mlr3pipelines", "mlr3learners", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  library("mlr3learners")
  task = mlr3::tsk("sonar")

  filter = flt("selected_features", learner = lrn("classif.rpart"))

  # Note: All filter scores are either 0 or 1, i.e. setting `filter.cutoff = 0.5` means that
  # we select all "selected features".

  graph = po("filter", filter = filter, filter.cutoff = 0.5) %>>%
    po("learner", mlr3::lrn("classif.log_reg"))

  graph$train(task)
}
#> $classif.log_reg.output
#> NULL
#> 
```
