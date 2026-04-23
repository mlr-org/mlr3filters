# Information Gain Filter

Information gain filter calling
[`FSelectorRcpp::information_gain()`](https://rdrr.io/pkg/FSelectorRcpp/man/information_gain.html)
in package
[FSelectorRcpp](https://CRAN.R-project.org/package=FSelectorRcpp). Set
parameter `"type"` to `"gainratio"` to calculate the gain ratio, or set
to `"symuncert"` to calculate the symmetrical uncertainty (see
[`FSelectorRcpp::information_gain()`](https://rdrr.io/pkg/FSelectorRcpp/man/information_gain.html)).
Default is `"infogain"`.

Argument `equal` defaults to `FALSE` for classification tasks, and to
`TRUE` for regression tasks.

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
-\> `FilterInformationGain`

## Methods

### Public methods

- [`FilterInformationGain$new()`](#method-FilterInformationGain-new)

- [`FilterInformationGain$clone()`](#method-FilterInformationGain-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Create a FilterInformationGain object.

#### Usage

    FilterInformationGain$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterInformationGain$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (requireNamespace("FSelectorRcpp")) {
  ## InfoGain (default)
  task = mlr3::tsk("sonar")
  filter = flt("information_gain")
  filter$calculate(task)
  head(filter$scores, 3)
  as.data.table(filter)

  ## GainRatio

  filterGR = flt("information_gain")
  filterGR$param_set$values = list("type" = "gainratio")
  filterGR$calculate(task)
  head(as.data.table(filterGR), 3)

}
#>    feature     score
#>     <char>     <num>
#> 1:     V11 0.2053399
#> 2:     V12 0.1802854
#> 3:      V9 0.1633805

if (mlr3misc::require_namespaces(c("mlr3pipelines", "FSelectorRcpp", "rpart"), quietly = TRUE)) {
  library("mlr3pipelines")
  task = mlr3::tsk("spam")

  # Note: `filter.frac` is selected randomly and should be tuned.

  graph = po("filter", filter = flt("information_gain"), filter.frac = 0.5) %>>%
    po("learner", mlr3::lrn("classif.rpart"))

  graph$train(task)

}
#> $classif.rpart.output
#> NULL
#> 
```
