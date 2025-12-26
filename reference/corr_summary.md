# Clean corr.test output

Converts corr.test output to tidy tibble with most important information
(IV, DV, r, n, t, p)

## Usage

``` r
corr_summary(corr_test_results, alpha = 0.05)
```

## Arguments

- corr_test_results:

  corr.test object

- alpha:

  Alpha level to test significance

## Value

tibble with clean output

## Examples

``` r
if (requireNamespace("psych", quietly = TRUE)) {
  ct <- psych::corr.test(mtcars[1:5])
  corr_summary(ct)
}
#> # A tibble: 20 × 9
#>    iv    dv         r     n     t        p p.adjust p_sig p.adjust_sig
#>    <chr> <chr>  <dbl> <dbl> <dbl>    <dbl>    <dbl> <lgl> <lgl>       
#>  1 mpg   cyl   -0.852    32 -8.92 6.11e-10 5.50e- 9 TRUE  TRUE        
#>  2 mpg   disp  -0.848    32 -8.75 9.38e-10 7.50e- 9 TRUE  TRUE        
#>  3 mpg   hp    -0.776    32 -6.74 1.79e- 7 8.94e- 7 TRUE  TRUE        
#>  4 mpg   drat   0.681    32  5.10 1.78e- 5 3.55e- 5 TRUE  TRUE        
#>  5 cyl   mpg   -0.852    32 -8.92 6.11e-10 5.50e- 9 TRUE  TRUE        
#>  6 cyl   disp   0.902    32 11.4  1.80e-12 1.80e-11 TRUE  TRUE        
#>  7 cyl   hp     0.832    32  8.23 3.48e- 9 2.43e- 8 TRUE  TRUE        
#>  8 cyl   drat  -0.700    32 -5.37 8.24e- 6 2.47e- 5 TRUE  TRUE        
#>  9 disp  mpg   -0.848    32 -8.75 9.38e-10 7.50e- 9 TRUE  TRUE        
#> 10 disp  cyl    0.902    32 11.4  1.80e-12 1.80e-11 TRUE  TRUE        
#> 11 disp  hp     0.791    32  7.08 7.14e- 8 4.29e- 7 TRUE  TRUE        
#> 12 disp  drat  -0.710    32 -5.53 5.28e- 6 2.11e- 5 TRUE  TRUE        
#> 13 hp    mpg   -0.776    32 -6.74 1.79e- 7 8.94e- 7 TRUE  TRUE        
#> 14 hp    cyl    0.832    32  8.23 3.48e- 9 2.43e- 8 TRUE  TRUE        
#> 15 hp    disp   0.791    32  7.08 7.14e- 8 4.29e- 7 TRUE  TRUE        
#> 16 hp    drat  -0.449    32 -2.75 9.99e- 3 9.99e- 3 TRUE  TRUE        
#> 17 drat  mpg    0.681    32  5.10 1.78e- 5 3.55e- 5 TRUE  TRUE        
#> 18 drat  cyl   -0.700    32 -5.37 8.24e- 6 2.47e- 5 TRUE  TRUE        
#> 19 drat  disp  -0.710    32 -5.53 5.28e- 6 2.11e- 5 TRUE  TRUE        
#> 20 drat  hp    -0.449    32 -2.75 9.99e- 3 9.99e- 3 TRUE  TRUE        
```
