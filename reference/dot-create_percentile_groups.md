# Create Percentile-Based Groups

This is an internal helper to create groups based on percentiles of an
IV.

## Usage

``` r
.create_percentile_groups(df, iv, cut_bottom, cut_top = NULL)
```

## Arguments

- df:

  A data frame.

- iv:

  Character name of the independent variable.

- cut_bottom:

  Numeric value for the bottom cutoff.

- cut_top:

  Numeric value for the top cutoff (optional).

## Value

A factor vector of group assignments.
