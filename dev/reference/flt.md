# Syntactic Sugar for Filter Construction

These functions complements
[mlr_filters](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters.md)
with a function in the spirit of
[mlr3::mlr_sugar](https://mlr3.mlr-org.com/reference/mlr_sugar.html).

## Usage

``` r
flt(.key, ...)

flts(.keys, ...)
```

## Arguments

- .key:

  (`character(1)`)  
  Key passed to the respective
  [dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
  to retrieve the object.

- ...:

  (any)  
  Additional arguments.

- .keys:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Keys passed to the respective
  [dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
  to retrieve multiple objects.

## Value

[Filter](https://mlr3filters.mlr-org.com/dev/reference/Filter.md).

## Examples

``` r
flt("correlation", method = "kendall")
#> 
#> ── <FilterCorrelation> correlation: Correlation ────────────────────────────────
#> • Task Types: regr
#> • Properties: missings
#> • Task Properties:
#> • Packages: stats
#> • Feature types: integer and numeric
flts(c("mrmr", "jmim"))
#> $mrmr
#> 
#> ── <FilterMRMR> mrmr: Minimum Redundancy Maximal Relevancy ─────────────────────
#> • Task Types: classif and regr
#> • Properties: -
#> • Task Properties:
#> • Packages: praznik
#> • Feature types: integer, numeric, factor, and ordered
#> 
#> $jmim
#> 
#> ── <FilterJMIM> jmim: Minimal Joint Mutual Information Maximization ────────────
#> • Task Types: classif and regr
#> • Properties: -
#> • Task Properties:
#> • Packages: praznik
#> • Feature types: integer, numeric, factor, and ordered
#> 
```
