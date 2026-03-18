# Changelog

## mlr3filters (development version)

## mlr3filters 0.9.0

CRAN release: 2025-09-12

- refactor: Field `param_set` of class `Filter` is now an active
  binding.
- feat: Added support for `logical`, `factor`, and `ordered` features to
  `FilterBoruta`.
- feat: Added cli package for class printer.
- fix: Use fresh resampling instance in each invocation in
  `FilterPerformance`.
- fix: `standardize` parameter in `FilterPermutation` works now as
  expected.

## mlr3filters 0.8.1

CRAN release: 2024-11-08

- compatibility: mlr3 0.22.0

## mlr3filters 0.8.0

CRAN release: 2024-04-10

- Added `FilterBoruta`
- Fixed issue with `FilterPerformance` where the arg `measure` wasn’t
  passed on
- Added `FilterUnivariateCox` (thanks to
  [@bblodfon](https://github.com/bblodfon))
- Parameter value `na.rm` is properly initialized to `TRUE` (thanks to
  [@bblodfon](https://github.com/bblodfon))
- Bugfix: property `missings` is now set correctly for
  `FilterFindCorrelation`
- Bugfix: `$hash` now works for `Filter`s

## mlr3filters 0.7.1

CRAN release: 2023-02-15

- Tagged multiple filters to be able of gracefully handling missing
  values.
- Added more supported feature types to FilterCarScore.
- Improved documentation.

## mlr3filters 0.7.0

CRAN release: 2023-01-06

- Features are now checked for missing values to improve error messages
  ([\#140](https://github.com/mlr-org/mlr3filters/issues/140))
- Removed deprecated functions
- Use featureless learner in defaults
  ([\#124](https://github.com/mlr-org/mlr3filters/issues/124))
- Field `task_type` of class `Filter` has been renamed to `task_types`.

## mlr3filters 0.6.0

CRAN release: 2022-09-02

- Add `FilterCarSurvScore`
  ([\#120](https://github.com/mlr-org/mlr3filters/issues/120),
  [@mllg](https://github.com/mllg))
- Use featureless learner instead of rpart as default learner for
  `FilterImportance` and `FilterPerformance`
  ([\#124](https://github.com/mlr-org/mlr3filters/issues/124))
- Add documentation for PipeOpFilter
- Add mlr3pipelines examples to help pages
  ([\#135](https://github.com/mlr-org/mlr3filters/issues/135),
  [@sebffischer](https://github.com/sebffischer))
- Add `label` arg to `Filter` class
  ([\#121](https://github.com/mlr-org/mlr3filters/issues/121),
  [@mllg](https://github.com/mllg))

## mlr3filters 0.5.0

CRAN release: 2022-01-25

- Add references to benchmark paper and praznik paper
  ([\#104](https://github.com/mlr-org/mlr3filters/issues/104))
- New filter `FilterSelectedFeatures` which makes use of embedded
  feature selection methods of learners. See the help page for more
  details ([\#102](https://github.com/mlr-org/mlr3filters/issues/102))
- Allow `NA` as task type. This makes it possible to use other tasks
  than `"regr"` or `"classif"` for certain filters,
  e.g. `FilterVariance`
  ([\#106](https://github.com/mlr-org/mlr3filters/issues/106))

## mlr3filters 0.4.2

CRAN release: 2021-07-12

- Fixes an issue where argument `nfeat` was not passed down to {praznik}
  filters ([\#97](https://github.com/mlr-org/mlr3filters/issues/97))

## mlr3filters 0.4.1

CRAN release: 2021-03-08

- Disable threading in praznik filters by default
  (5f24742e9b92f6a5f828c4f755be3fb53427afdb,
  [@mllg](https://github.com/mllg)) Enable by setting hyperparameter
  `threads` \>= 2 or to `0` for auto-detection of available cores
  ([\#93](https://github.com/mlr-org/mlr3filters/issues/93),
  [@mllg](https://github.com/mllg))
- Document return type of private `.calculate()`
  ([\#92](https://github.com/mlr-org/mlr3filters/issues/92),
  [@mllg](https://github.com/mllg))
- Allow `NA` in returned vectors. Features with missing values as well
  as features with no calculated score are automatically ranked last, in
  a random order.
  ([\#92](https://github.com/mlr-org/mlr3filters/issues/92),
  [@mllg](https://github.com/mllg))
- praznik filters now also support `regr` Tasks
  ([\#90](https://github.com/mlr-org/mlr3filters/issues/90),
  [@bommert](https://github.com/bommert))

## mlr3filters 0.4.0

CRAN release: 2020-11-10

- Add ReliefF filter
  ([\#86](https://github.com/mlr-org/mlr3filters/issues/86))
- Fix praznik scores calculation: praznik filters are not monotone in
  the selected features due to their iterative fashion. E.g., the first
  selected feature can have a score of 5, the second selected feature a
  score of 10. This version replaces the praznik scores by a simple
  sequence ([\#87](https://github.com/mlr-org/mlr3filters/issues/87),
  [@mllg](https://github.com/mllg))

## mlr3filters 0.3.0

CRAN release: 2020-07-18

- Add Permutation
  ([\#70](https://github.com/mlr-org/mlr3filters/issues/70))
- Add [`flts()`](https://mlr3filters.mlr-org.com/dev/reference/flt.md)
  ([\#77](https://github.com/mlr-org/mlr3filters/issues/77))
- Github Actions: set cron job to 4am to avoid potential download issues
  with R-devel on macOS
- Filters now have a help method `$help()` which opens the respective
  help page ([\#68](https://github.com/mlr-org/mlr3filters/issues/68))

## mlr3filters 0.2.0

CRAN release: 2020-03-12

### Internal

- Use `private$.calculate` instead of public “calculate” method for
  Filters
- switch from Travis to GitHub Actions
- Use Roxygen R6 notation for docs

### Enhancements

- new filter `FilterFindCorrelation`
  ([\#62](https://github.com/mlr-org/mlr3filters/issues/62),
  [@mb706](https://github.com/mb706))

## mlr3filters 0.1.1

CRAN release: 2019-12-08

- Replace dependency `Metrics` with `mlr3measures`.

## mlr3filters 0.1.0

CRAN release: 2019-09-04

- Initial CRAN release.
