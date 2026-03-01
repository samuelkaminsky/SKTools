# Convert number to equivalent letter

Converts a number to an equivalent letter, with an option to concatenate
a row value. Useful for adding data to existing Google Sheets

## Usage

``` r
num2letter(x, number = "")
```

## Arguments

- x:

  Number to be converted to letter

- number:

  Optional suffix to append to letter

## Value

Character string a letter and optional appended number

## Examples

``` r
num2letter(1)
#> [1] "A"
num2letter(26)
#> [1] "Z"
num2letter(1, 1)
#> [1] "A1"
```
