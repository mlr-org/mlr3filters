# mlr3filters 0.4.1.9000

- Internal changes only.


# mlr3filters 0.4.1

- Internal changes only.


# mlr3filters 0.4.0.9001

- Disable threading in praznik filters by default.
  Enable by setting hyperparameter `threads` >= 2 or to `0` for auto-detection of available cores (#93, @mllg)


# mlr3filters 0.4.0.9000

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
