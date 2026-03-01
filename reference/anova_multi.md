# Conduct One-Way ANOVAs on Multiple DVs

Conduct one-way ANOVAs on multiple DVs

## Usage

``` r
anova_multi(df, iv, dvs, print = FALSE)
```

## Arguments

- df:

  Dataframe with test data

- iv:

  Name of independent variable

- dvs:

  Names of dependent variables to be inserted into dplyr::select()

- print:

  Logical indicating whether or not ns and proportions of iv are printed

## Value

Data frame of tidy ANOVA post-hoc results, also prints Ns and
percentages in each level of the IV

## Examples

``` r
anova_multi(mtcars, iv = cyl, dvs = c(mpg, disp))
#> # A tibble: 2 × 12
#>   DV      `4`   `6`   `8`    df   sumsq  meansq statistic p.value  `6-4` `8-4`
#>   <chr> <dbl> <dbl> <dbl> <dbl>   <dbl>   <dbl>     <dbl>   <dbl>  <dbl> <dbl>
#> 1 mpg    26.7  19.7  15.1     2    825.    412.      39.7       0 0.0003     0
#> 2 disp  105.  183.  353.      2 398891. 199445.      74.8       0 0.0107     0
#> # ℹ 1 more variable: `8-6` <dbl>
```
