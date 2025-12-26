# List Variable Names

Creates a vector of variable names from a dataframe or tibble

## Usage

``` r
list_names(df, ...)
```

## Arguments

- df:

  Dataframe with test data

- ...:

  Names of variables to be inserted into dplyr::select()

## Value

Named vector of variables

## Examples

``` r
list_names(mtcars, mpg, cyl)
#>   mpg   cyl 
#> "mpg" "cyl" 
```
