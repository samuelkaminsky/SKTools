# Dataframe Descriptives and Frequencies

Calculates descriptives and frequencies of every Column in a dataframe.
Heavily inspired by Ujjwal Karn's XDA package.

## Usage

``` r
descriptives(df, frequencies = FALSE)
```

## Arguments

- df:

  Dataframe with data

- frequencies:

  Logical to indicate whether or not to calculate frequencies for each
  variable as a list column

## Value

Dataframe of descriptives and frequencies for each variable and value

## Examples

``` r
descriptives(mtcars)
#> # A tibble: 11 × 20
#>    var   class      mean median    max   min      sd  range    iqr skewness
#>    <chr> <chr>     <dbl>  <dbl>  <dbl> <dbl>   <dbl>  <dbl>  <dbl>    <dbl>
#>  1 mpg   numeric  20.1    19.2   33.9  10.4    6.03   23.5    7.38    0.640
#>  2 cyl   numeric   6.19    6      8     4      1.79    4      4      -0.183
#>  3 disp  numeric 231.    196.   472    71.1  124.    401.   205.      0.400
#>  4 hp    numeric 147.    123    335    52     68.6   283     83.5     0.761
#>  5 drat  numeric   3.60    3.70   4.93  2.76   0.535   2.17   0.84    0.279
#>  6 wt    numeric   3.22    3.32   5.42  1.51   0.978   3.91   1.03    0.444
#>  7 qsec  numeric  17.8    17.7   22.9  14.5    1.79    8.4    2.01    0.387
#>  8 vs    numeric   0.438   0      1     0      0.504   1      1       0.252
#>  9 am    numeric   0.406   0      1     0      0.499   1      1       0.382
#> 10 gear  numeric   3.69    4      5     3      0.738   2      1       0.555
#> 11 carb  numeric   2.81    2      8     1      1.62    7      2       1.10 
#> # ℹ 10 more variables: kurtosis <dbl>, n_unique <int>, n <int>,
#> #   n_missing <int>, perc_missing <dbl>, `1%` <dbl>, `25%` <dbl>, `50%` <dbl>,
#> #   `75%` <dbl>, `99%` <dbl>
```
