# Remove duplicates based on two columns, ignoring their order

Remove duplicates based on two columns, ignoring their order

## Usage

``` r
distinct_2col(df, col1, col2)
```

## Arguments

- df:

  Dataframe

- col1:

  Quoted name of first column

- col2:

  Quoted name of second column

## Value

Dataframe with duplicates removed

## Examples

``` r
df <- tibble::tibble(
  a = c("A", "B", "C"),
  b = c("B", "A", "D")
)
distinct_2col(df, "a", "b")
#> # A tibble: 1 × 2
#>   a     b    
#>   <chr> <chr>
#> 1 A     B    
```
