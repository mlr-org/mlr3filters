# mlr3filters 0.7.1-9000

- Fixed issue with `FilterPerformance` where the arg `measure` wasn't passed on
- Added `FilterUnivariateCox` (thanks to @bblodfon)
- Parameter value `na.rm` is properly initialized to `TRUE` (thanks to @bblodfon)
- Bugfix: property `missings` is now set correctly for `FilterFindCorrelation`

# mlr3filters 0.7.1

- Tagged multiple filters to be able of gracefully handling missing values.
- Added more supported feature types to FilterCarScore.
- Improved documentation.

# mlr3filters 0.7.0

- Features are now checked for missing values to improve error messages (#140)
- Removed deprecated functions
- Use featureless learner in defaults (#124)
- Field `task_type` of class `Filter` has been renamed to `task_types`.

# mlr3filters 0.6.0

- Add `FilterCarSurvScore` (#120, @mllg)
- Use featureless learner instead of rpart as default learner for `FilterImportance` and `FilterPerformance` (#124)
- Add documentation for PipeOpFilter
- Add mlr3pipelines examples to help pages (#135, @sebffischer)
- Add `label` arg to `Filter` class (#121, @mllg)

# mlr3filters 0.5.0

- Add references to benchmark paper and praznik paper (#104)
- New filter `FilterSelectedFeatures` which makes use of embedded feature selection methods of learners.
  See the help page for more details (#102)
- Allow `NA` as task type.
  This makes it possible to use other tasks than `"regr"` or `"classif"` for certain filters, e.g. `FilterVariance` (#106)


# mlr3filters 0.4.2

- Fixes an issue where argument `nfeat` was not passed down to {praznik} filters (#97)


# mlr3filters 0.4.1

- Disable threading in praznik filters by default (5f24742e9b92f6a5f828c4f755be3fb53427afdb, @mllg)
  Enable by setting hyperparameter `threads` >= 2 or to `0` for auto-detection of available cores (#93, @mllg)
- Document return type of private `.calculate()` (#92, @mllg)
- Allow `NA` in returned vectors.
  Features with missing values as well as features with no calculated score are automatically ranked last, in a random order.  (#92, @mllg)
- praznik filters now also support `regr` Tasks (#90, @bommert)


# mlr3filters 0.4.0

- Add ReliefF filter (#86)
- Fix praznik scores calculation: praznik filters are not monotone in the selected features due to their iterative fashion. E.g., the first selected feature can have a score of 5, the second selected feature a score of 10. This version replaces the praznik scores by a simple sequence (#87, @mllg)


# mlr3filters 0.3.0

- Add Permutation (#70)
- Add `flts()` (#77)
- Github Actions: set cron job to 4am to avoid potential download issues with R-devel on macOS
- Filters now have a help method `$help()` which opens the respective help page (#68)


# mlr3filters 0.2.0

## Internal

* Use `private$.calculate` instead of public "calculate" method for Filters
* switch from Travis to GitHub Actions
* Use Roxygen R6 notation for docs

## Enhancements

* new filter `FilterFindCorrelation` (#62, @mb706)


# mlr3filters 0.1.1

* Replace dependency `Metrics` with `mlr3measures`.


# mlr3filters 0.1.0

* Initial CRAN release.
