# Checks quality of data in a data frame

Checks quality of data in a data frame

## Usage

``` r
quality_check(df)
```

## Arguments

- df:

  name of dataframe

## Value

Prints message that identifies columns with no variance and those with
strong or moderate skewness.

## Author

Eric Knudsen \<eknudsen88@gmail.com\>

## Examples

``` r
df <- tibble::tibble(
  no_var = c(1, 1, 1, 1),
  skewed = c(1, 1, 1, 100)
)
quality_check(df)
#> .........NO VARIANCE.........
#> no_var
#> 
#> .........SKEWNESS.........
#> Strong (-): 
#> Strong (+): 
#> Moderate (-): 
#> Moderate (+): 
```
