# append_2_prepend

Move string at end of column name to beginning

## Usage

``` r
append_2_prepend(df, string, sep = "_")
```

## Arguments

- df:

  Dataframe

- string:

  String at end to move to beginning

- sep:

  String to insert between prepended string and rest of variable name

## Value

Data frame with corrected column names

## Examples

``` r
df <- tibble::tibble(
  x_suff = 1:5,
  y_suff = 1:5,
  z = 1:5
)
append_2_prepend(df, "suff", "_")
#> # A tibble: 5 × 3
#>   suff_x suff_y     z
#>    <int>  <int> <int>
#> 1      1      1     1
#> 2      2      2     2
#> 3      3      3     3
#> 4      4      4     4
#> 5      5      5     5
```
