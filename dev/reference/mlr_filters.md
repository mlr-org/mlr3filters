# Dictionary of Filters

A simple
[mlr3misc::Dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
storing objects of class
[Filter](https://mlr3filters.mlr-org.com/dev/reference/Filter.md). Each
Filter has an associated help page, see `mlr_filters_[id]`.

This dictionary can get populated with additional filters by add-on
packages.

For a more convenient way to retrieve and construct filters, see
[`flt()`](https://mlr3filters.mlr-org.com/dev/reference/flt.md).

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
[`Filter`](https://mlr3filters.mlr-org.com/dev/reference/Filter.md),
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
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

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
#> Key: <key>
#>                   key                                                    label
#>                <char>                                                   <char>
#>  1:             anova                                             ANOVA F-Test
#>  2:               auc                           Area Under the ROC Curve Score
#>  3:            boruta                                                   Boruta
#>  4:          carscore                   Correlation-Adjusted coRrelation Score
#>  5:      carsurvscore          Correlation-Adjusted coRrelation Survival Score
#>  6:              cmim      Minimal Conditional Mutual Information Maximization
#>  7:       correlation                                              Correlation
#>  8:              disr                       Double Input Symmetrical Relevance
#>  9:          ensemble                                                     meta
#> 10:  find_correlation                                  Correlation-based Score
#> 11:        importance                                         Importance Score
#> 12:  information_gain                                         Information Gain
#> 13:               jmi                                 Joint Mutual Information
#> 14:              jmim            Minimal Joint Mutual Information Maximization
#> 15:      kruskal_test                                      Kruskal-Wallis Test
#> 16:               mim                          Mutual Information Maximization
#> 17:              mrmr                     Minimum Redundancy Maximal Relevancy
#> 18:             njmim Minimal Normalized Joint Mutual Information Maximization
#> 19:       performance                                   Predictive Performance
#> 20:       permutation                                        Permutation Score
#> 21:            relief                                                   RELIEF
#> 22: selected_features                               Embedded Feature Selection
#> 23:    univariate_cox                            Univariate Cox Survival Score
#> 24:          variance                                                 Variance
#>                   key                                                    label
#>                <char>                                                   <char>
#>                    task_types task_properties
#>                        <list>          <list>
#>  1:                   classif                
#>  2:                   classif        twoclass
#>  3:              regr,classif                
#>  4:                      regr                
#>  5:                      surv                
#>  6:              classif,regr                
#>  7:                      regr                
#>  8:              classif,regr                
#>  9: classif,regr,unsupervised                
#> 10:                        NA                
#> 11:                   classif                
#> 12:              classif,regr                
#> 13:              classif,regr                
#> 14:              classif,regr                
#> 15:                   classif                
#> 16:              classif,regr                
#> 17:              classif,regr                
#> 18:              classif,regr                
#> 19:                   classif                
#> 20:                   classif                
#> 21:              classif,regr                
#> 22:                   classif                
#> 23:                      surv                
#> 24:                        NA                
#>                    task_types task_properties
#>                        <list>          <list>
#>                                                                              params
#>                                                                              <list>
#>  1:                                                                                
#>  2:                                                                                
#>  3:                          pValue,mcAdj,maxRuns,doTrace,holdHistory,getImp,...[8]
#>  4:                                                         lambda,diagonal,verbose
#>  5:                                                              maxIPCweight,denom
#>  6:                                                                         threads
#>  7:                                                                      use,method
#>  8:                                                                         threads
#>  9: weights,rank_transform,filter_score_transform,result_score_transform,aggregator
#> 10:                                                                      use,method
#> 11:                                                                          method
#> 12:                                                 type,equal,discIntegers,threads
#> 13:                                                                         threads
#> 14:                                                                         threads
#> 15:                                                                       na.action
#> 16:                                                                         threads
#> 17:                                                                         threads
#> 18:                                                                         threads
#> 19:                                                                          method
#> 20:                                                                 standardize,nmc
#> 21:                                                      neighboursCount,sampleSize
#> 22:                                                                          method
#> 23:                                                                                
#> 24:                                                                           na.rm
#>                                                                              params
#>                                                                              <list>
#>                                               feature_types          packages
#>                                                      <list>            <list>
#>  1:                                         integer,numeric             stats
#>  2:                                         integer,numeric      mlr3measures
#>  3:                  logical,integer,numeric,factor,ordered            Boruta
#>  4:                                 logical,integer,numeric              care
#>  5:                                         integer,numeric carSurv,mlr3proba
#>  6:                          integer,numeric,factor,ordered           praznik
#>  7:                                         integer,numeric             stats
#>  8:                          integer,numeric,factor,ordered           praznik
#>  9: logical,integer,numeric,character,factor,ordered,...[8]     mlr3pipelines
#> 10:                                         integer,numeric             stats
#> 11: logical,integer,numeric,character,factor,ordered,...[8]              mlr3
#> 12:                          integer,numeric,factor,ordered     FSelectorRcpp
#> 13:                          integer,numeric,factor,ordered           praznik
#> 14:                          integer,numeric,factor,ordered           praznik
#> 15:                                         integer,numeric             stats
#> 16:                          integer,numeric,factor,ordered           praznik
#> 17:                          integer,numeric,factor,ordered           praznik
#> 18:                          integer,numeric,factor,ordered           praznik
#> 19: logical,integer,numeric,character,factor,ordered,...[8] mlr3,mlr3measures
#> 20: logical,integer,numeric,character,factor,ordered,...[8] mlr3,mlr3measures
#> 21:                          integer,numeric,factor,ordered     FSelectorRcpp
#> 22: logical,integer,numeric,character,factor,ordered,...[8]              mlr3
#> 23:                                 integer,numeric,logical          survival
#> 24:                                         integer,numeric             stats
#>                                               feature_types          packages
#>                                                      <list>            <list>
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
