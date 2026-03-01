# Conducts One-Way ANOVAs on Multiple DVs at Multiple Cut Points

Conduct one-way ANOVAs on multiple DVs at various cutpoints of the iv

## Usage

``` r
anova_multi_all(df, ivs, dvs, perc = 0.05, print = FALSE)
```

## Arguments

- df:

  Dataframe with test data

- ivs:

  Names of independent variables to be inserted into dplyr::select()

- dvs:

  Names of dependent variables to be inserted into dplyr::select()

- perc:

  Nth percentile to conduct ANOVA at

- print:

  TRUE to print progress as it goes

## Value

Data frame of tidy ANOVA F test and post-hoc results, also includes
descriptives about each level of the IV

## Examples

``` r
anova_multi_all(mtcars, ivs = c(disp, hp), dvs = mpg)
#> # A tibble: 380 × 20
#>    iv    dv    Cutoff.Bottom Cutoff.Top Cutoff.Bottom.Num Cutoff.Bottom.Top
#>    <chr> <chr> <chr>         <chr>                  <dbl>             <dbl>
#>  1 disp  mpg   10%           10%                     80.6              80.6
#>  2 disp  mpg   10%           15%                     80.6             103. 
#>  3 disp  mpg   10%           20%                     80.6             120. 
#>  4 disp  mpg   10%           25%                     80.6             121. 
#>  5 disp  mpg   10%           30%                     80.6             142. 
#>  6 disp  mpg   10%           35%                     80.6             146. 
#>  7 disp  mpg   10%           40%                     80.6             160  
#>  8 disp  mpg   10%           45%                     80.6             167. 
#>  9 disp  mpg   10%           50%                     80.6             196. 
#> 10 disp  mpg   10%           55%                     80.6             259. 
#> # ℹ 370 more rows
#> # ℹ 14 more variables: df <dbl>, sumsq <dbl>, meansq <dbl>, statistic <dbl>,
#> #   p.value <dbl>, mean_0 <dbl>, mean_1 <dbl>, mean_2 <dbl>, n_0 <int>,
#> #   n_1 <int>, n_2 <int>, `p.value.1-0` <dbl>, `p.value.2-0` <dbl>,
#> #   `p.value.2-1` <dbl>
```
