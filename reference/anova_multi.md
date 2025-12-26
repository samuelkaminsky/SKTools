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
#>     DV        4        6     8    6-4 8-4    8-6
#> 1  mpg  26.6636  19.7429  15.1 0.0003   0 0.0112
#> 2 disp 105.1364 183.3143 353.1 0.0107   0 0.0000
```
