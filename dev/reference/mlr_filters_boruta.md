# Burota Filter

Filter using the Boruta algorithm for feature selection. If
`keep = "tentative"`, confirmed and tentative features are returned.
Note that there is no ordering in the selected features. Selected
features get a score of 1, deselected features get a score of 0. The
order of selected features is random. In combination with
[mlr3pipelines](https://CRAN.R-project.org/package=mlr3pipelines), only
the filter criterion `cutoff` makes sense.

## Initial parameter values

- `threads`:

  - Actual default: 0, triggering auto-detection of the number of CPUs.

  - Adjusted value: 1.

  - Reason for change: Conflicting with parallelization via
    [future](https://CRAN.R-project.org/package=future).

## References

Kursa MB, Rudnicki WR (2010). “Feature Selection with the Boruta
Package.” *Journal of Statistical Software*, **36**(11), 1-13.

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
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Super class

[`mlr3filters::Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md)
-\> `FilterBoruta`

## Methods

### Public methods

- [`FilterBoruta$new()`](#method-FilterBoruta-new)

- [`FilterBoruta$clone()`](#method-FilterBoruta-clone)

Inherited methods

- [`mlr3filters::Filter$calculate()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-calculate)
- [`mlr3filters::Filter$format()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-format)
- [`mlr3filters::Filter$help()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-help)
- [`mlr3filters::Filter$print()`](https://mlr3filters.mlr-org.com/dev/reference/Filter.html#method-print)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    FilterBoruta$new()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FilterBoruta$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# \donttest{
  if (requireNamespace("Boruta")) {
   task = mlr3::tsk("sonar")
   filter = flt("boruta")
   filter$calculate(task)
   as.data.table(filter)
  }
#> Loading required namespace: Boruta
#>     feature score
#>      <char> <num>
#>  1:     V10     1
#>  2:     V22     1
#>  3:      V1     1
#>  4:     V47     1
#>  5:     V12     1
#>  6:     V27     1
#>  7:      V5     1
#>  8:     V11     1
#>  9:     V15     1
#> 10:     V45     1
#> 11:     V18     1
#> 12:     V21     1
#> 13:      V9     1
#> 14:     V37     1
#> 15:     V13     1
#> 16:     V31     1
#> 17:     V35     1
#> 18:     V26     1
#> 19:     V19     1
#> 20:     V16     1
#> 21:     V17     1
#> 22:     V20     1
#> 23:     V48     1
#> 24:     V36     1
#> 25:     V46     1
#> 26:     V52     1
#> 27:     V28     1
#> 28:     V51     1
#> 29:     V44     1
#> 30:     V49     1
#> 31:     V23     1
#> 32:      V4     1
#> 33:     V60     0
#> 34:     V58     0
#> 35:     V57     0
#> 36:      V8     0
#> 37:     V56     0
#> 38:     V54     0
#> 39:     V41     0
#> 40:     V32     0
#> 41:     V53     0
#> 42:     V29     0
#> 43:     V50     0
#> 44:     V24     0
#> 45:     V39     0
#> 46:     V30     0
#> 47:     V59     0
#> 48:     V14     0
#> 49:      V6     0
#> 50:     V55     0
#> 51:      V2     0
#> 52:     V25     0
#> 53:      V7     0
#> 54:     V42     0
#> 55:     V33     0
#> 56:     V38     0
#> 57:      V3     0
#> 58:     V40     0
#> 59:     V43     0
#> 60:     V34     0
#>     feature score
#>      <char> <num>
# }
```
