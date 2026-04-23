# Dictionary of Filters

A simple
[mlr3misc::Dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
storing objects of class
[Filter](https://mlr3filters.mlr-org.com/reference/Filter.md). Each
Filter has an associated help page, see `mlr_filters_[id]`.

This dictionary can get populated with additional filters by add-on
packages.

For a more convenient way to retrieve and construct filters, see
[`flt()`](https://mlr3filters.mlr-org.com/reference/flt.md).

## Usage

``` r
mlr_filters
```

## Format

[R6::R6Class](https://r6.r-lib.org/reference/R6Class.html) object

## Usage

See
[mlr3misc::Dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html).

## See also

Other Filter:
[`Filter`](https://mlr3filters.mlr-org.com/reference/Filter.md),
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
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/reference/mlr_filters_variance.md)

## Examples

``` r
mlr_filters$keys()
#>  [1] "anova"             "auc"               "boruta"           
#>  [4] "carscore"          "carsurvscore"      "cmim"             
#>  [7] "correlation"       "disr"              "ensemble"         
#> [10] "find_correlation"  "importance"        "information_gain" 
#> [13] "jmi"               "jmim"              "kruskal_test"     
#> [16] "mim"               "mrmr"              "njmim"            
#> [19] "performance"       "permutation"       "relief"           
#> [22] "selected_features" "univariate_cox"    "variance"         
as.data.table(mlr_filters)
#> Error in assert_list(filters, types = "Filter", min.len = 1): argument "filters" is missing, with no default
mlr_filters$get("mim")
#> 
#> ── <FilterMIM> mim: Mutual Information Maximization ────────────────────────────
#> • Task Types: classif and regr
#> • Properties: -
#> • Task Properties:
#> • Packages: praznik
#> • Feature types: integer, numeric, factor, and ordered
flt("anova")
#> 
#> ── <FilterAnova> anova: ANOVA F-Test ───────────────────────────────────────────
#> • Task Types: classif
#> • Properties: -
#> • Task Properties:
#> • Packages: stats
#> • Feature types: integer and numeric
```
