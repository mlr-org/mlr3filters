# Filter Base Class

Base class for filters. Predefined filters are stored in the
[dictionary](https://mlr3misc.mlr-org.com/reference/Dictionary.html)
[mlr_filters](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters.md).
A Filter calculates a score for each feature of a task. Important
features get a large value and unimportant features get a small value.
Note that filter scores may also be negative.

## Details

Some features support partial scoring of the feature set: If `nfeat` is
not `NULL`, only the best `nfeat` features are guaranteed to get a
score. Additional features may be ignored for computational reasons, and
then get a score value of `NA`.

## See also

Other Filter:
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
[`mlr_filters_selected_features`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_selected_features.md),
[`mlr_filters_univariate_cox`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_univariate_cox.md),
[`mlr_filters_variance`](https://mlr3filters.mlr-org.com/dev/reference/mlr_filters_variance.md)

## Public fields

- `id`:

  (`character(1)`)  
  Identifier of the object. Used in tables, plot and text output.

- `label`:

  (`character(1)`)  
  Label for this object. Can be used in tables, plot and text output
  instead of the ID.

- `task_types`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Set of supported task types, e.g. `"classif"` or `"regr"`. Can be set
  to the scalar value `NA` to allow any task type.

  For a complete list of possible task types (depending on the loaded
  packages), see
  [`mlr_reflections$task_types$type`](https://mlr3.mlr-org.com/reference/mlr_reflections.html).

- `task_properties`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  [mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html)task
  properties.

- `feature_types`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Feature types of the filter.

- `packages`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Packages which this filter is relying on.

- `man`:

  (`character(1)`)  
  String in the format `[pkg]::[topic]` pointing to a manual page for
  this object. Defaults to `NA`, but can be set by child classes.

- `scores`:

  Stores the calculated filter score values as named numeric vector. The
  vector is sorted in decreasing order with possible `NA` values last.
  The more important the feature, the higher the score. Tied values
  (this includes `NA` values) appear in a random, non-deterministic
  order.

## Active bindings

- `param_set`:

  ([paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html))  
  Set of hyperparameters.

- `properties`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Properties of the filter. Currently, only `"missings"` is supported. A
  filter has the property `"missings"`, iff the filter can handle
  missing values in the features in a graceful way. Otherwise, an
  assertion is thrown if missing values are detected.

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

- [`Filter$new()`](#method-Filter-new)

- [`Filter$format()`](#method-Filter-format)

- [`Filter$print()`](#method-Filter-print)

- [`Filter$help()`](#method-Filter-help)

- [`Filter$calculate()`](#method-Filter-calculate)

- [`Filter$clone()`](#method-Filter-clone)

------------------------------------------------------------------------

### Method `new()`

Create a Filter object.

#### Usage

    Filter$new(
      id,
      task_types,
      task_properties = character(),
      param_set = ps(),
      feature_types = character(),
      packages = character(),
      label = NA_character_,
      man = NA_character_
    )

#### Arguments

- `id`:

  (`character(1)`)  
  Identifier for the filter.

- `task_types`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Types of the task the filter can operator on. E.g., `"classif"` or
  `"regr"`. Can be set to scalar `NA` to allow any task type.

- `task_properties`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Required task properties, see
  [mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html). Must be a
  subset of
  [`mlr_reflections$task_properties`](https://mlr3.mlr-org.com/reference/mlr_reflections.html).

- `param_set`:

  ([paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html))  
  Set of hyperparameters.

- `feature_types`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Feature types the filter operates on. Must be a subset of
  [`mlr_reflections$task_feature_types`](https://mlr3.mlr-org.com/reference/mlr_reflections.html).

- `packages`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Set of required packages. Note that these packages will be loaded via
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html), and are
  not attached.

- `label`:

  (`character(1)`)  
  Label for the new instance.

- `man`:

  (`character(1)`)  
  String in the format `[pkg]::[topic]` pointing to a manual page for
  this object. The referenced help package can be opened via method
  `$help()`.

------------------------------------------------------------------------

### Method [`format()`](https://rdrr.io/r/base/format.html)

Format helper for Filter class

#### Usage

    Filter$format(...)

#### Arguments

- `...`:

  (ignored).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Printer for Filter class

#### Usage

    Filter$print()

------------------------------------------------------------------------

### Method [`help()`](https://rdrr.io/r/utils/help.html)

Opens the corresponding help page referenced by field `$man`.

#### Usage

    Filter$help()

------------------------------------------------------------------------

### Method `calculate()`

Calculates the filter score values for the provided
[mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html) and stores
them in field `scores`. `nfeat` determines the minimum number of
features to score (see details), and defaults to the number of features
in `task`. Loads required packages and then calls `private$.calculate()`
of the respective subclass.

This private method is is expected to return a numeric vector, uniquely
named with (a subset of) feature names. The returned vector may have
missing values. Features with missing values as well as features with no
calculated score are automatically ranked last, in a random order. If
the task has no rows, each feature gets the score `NA`.

#### Usage

    Filter$calculate(task, nfeat = NULL)

#### Arguments

- `task`:

  ([mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html))  
  [mlr3::Task](https://mlr3.mlr-org.com/reference/Task.html) to
  calculate the filter scores for.

- `nfeat`:

  ([`integer()`](https://rdrr.io/r/base/integer.html))  
  The minimum number of features to calculate filter scores for.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Filter$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
