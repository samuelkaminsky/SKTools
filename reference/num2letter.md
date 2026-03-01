# Convert number to equivalent letter

Converts a number to an equivalent letter, with an option to concatenate
a row value. Useful for adding data to existing Google Sheets

## Usage

``` r
num2letter(x, number = "")
```

## Arguments

- x:

  Vector of numbers to be converted to letters

- number:

  Optional suffix to append to each letter

## Value

Character vector of letters with optional appended numbers

## Examples

``` r
num2letter(1)
#> [1] "A"
num2letter(26)
#> [1] "Z"
num2letter(1, 1)
#> [1] "A1"
num2letter(1:3, 10:12)
#> [1] "A10" "B11" "C12"
```
