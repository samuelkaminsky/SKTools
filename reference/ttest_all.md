# Conduct T-Tests at every nth percentile for list of IVs and DVs

Conduct T-Tests at specified percentile intervals for list of IVs and
DVs

## Usage

``` r
ttest_all(df, ivs, dvs, perc = 0.05)
```

## Arguments

- df:

  Dataframe with test data

- ivs:

  Names of independent variables to be inserted into dplyr::select()

- dvs:

  Names of dependent variables to be inserted into dplyr::select()

- perc:

  Nth percentile to conduct T-Test at

## Value

Data frame of tidy t.test results

## Examples

``` r
ttest_all(mtcars, ivs = c("disp", "hp"), dvs = "mpg")
#> # A tibble: 34 × 19
#>    IV    DV    Cutoff.Perc Cutoff.Num estimate estimate1 estimate2 statistic
#>    <chr> <chr> <chr>            <dbl>    <dbl>     <dbl>     <dbl>     <dbl>
#>  1 disp  mpg   5%                77.4    12.9       32.2      19.3      6.44
#>  2 disp  mpg   10%               80.6    12.5       31        18.5      7.49
#>  3 disp  mpg   15%              103.     12.8       30.9      18.1      9.47
#>  4 disp  mpg   20%              120.     10.6       28.4      17.8      5.43
#>  5 disp  mpg   25%              121.     10.7       28.1      17.4      6.11
#>  6 disp  mpg   30%              142.      9.89      26.9      17        5.96
#>  7 disp  mpg   35%              146.      9.36      26.2      16.9      5.58
#>  8 disp  mpg   40%              160       9.59      26.1      16.5      6.22
#>  9 disp  mpg   45%              167.      9.36      25.4      16.0      6.50
#> 10 disp  mpg   50%              196.      8.82      24.5      15.7      6.09
#> # ℹ 24 more rows
#> # ℹ 11 more variables: p.value <dbl>, parameter <dbl>, conf.low <dbl>,
#> #   conf.high <dbl>, method <chr>, alternative <chr>, `0` <int>, `1` <int>,
#> #   cd.est <dbl>, cd.mag <chr>, sig <lgl>
```
