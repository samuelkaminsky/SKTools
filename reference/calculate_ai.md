# Calculate Adverse Impact Metrics

Calculates adverse impact metrics

## Usage

``` r
calculate_ai(
  df,
  groupings,
  stage1,
  stage2,
  n_min = 0,
  prop_min = 0,
  only_max = FALSE,
  correct = TRUE
)
```

## Arguments

- df:

  Dataframe with passrate information. Must include columns for each
  grouping of interest and columns with logicals indicating success at
  each stage

- groupings:

  Character vector with names of each column containing grouping
  variables (e.g, race, gender, etc.)

- stage1:

  Unquoted column name of column indicating whether or not a row should
  be counted in the calculations (i.e., the denominator). Column must be
  logical.

- stage2:

  Unquoted column name of column indicating whether or not a row should
  be counted as a 'Pass' in the calculations (i.e., the numerator).
  Column must be logical.

- n_min:

  Minimum n count for a group to be included in the calculation

- prop_min:

  Minimum percentage for a group to be included in the calculation

- only_max:

  Only calculate adverse impact using the group with the highest
  selection ratio as the denominator

- correct:

  a logical indicating whether Yates' continuity correction should be
  applied where possible.

## Value

List with two data frames. The first includes all selection ratios, the
second includes all adverse impact calculation

- selection_ratio:

  Dataframe with selection ratios

- adverse_impact:

  Dataframe with adverse impact metrics, including adverse impact ratio,
  Cohen's H, Z score test of two proportions, Pearson's chi-squared test
  of proportions, and Fisher's exact

## Details

Calculates selection ratios and adverse impact using Fisher's Exact
Test, Z-test for two proportions, and Chi-Squared test.

## Examples

``` r
df <- tibble::tibble(
  gender = c(rep("Male", 10), rep("Female", 10)),
  applied = c(rep(TRUE, 10), rep(TRUE, 10)),
  hired = c(rep(TRUE, 5), rep(FALSE, 5), rep(TRUE, 8), rep(FALSE, 2))
)
calculate_ai(df, groupings = "gender", stage1 = applied, stage2 = hired)
#> Warning: There were 2 warnings in `dplyr::mutate()`.
#> The first warning was:
#> ℹ In argument: `chi =
#>   list(broom::tidy(stats::prop.test(as.matrix(.data$conting), correct =
#>   correct)))`.
#> ℹ In row 1.
#> Caused by warning in `stats::prop.test()`:
#> ! Chi-squared approximation may be incorrect
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 1 remaining warning.
#> $selection_ratio
#> # A tibble: 2 × 5
#>   Grouping Group  applied_n hired_n    SR
#>   <chr>    <chr>      <int>   <int> <dbl>
#> 1 gender   Female        10       8   0.8
#> 2 gender   Male          10       5   0.5
#> 
#> $adverse_impact
#> # A tibble: 2 × 10
#>   Grouping Numerator Denominator ai_ratio      H     Z   chi p_value_chi
#>   <chr>    <chr>     <chr>          <dbl>  <dbl> <dbl> <dbl>       <dbl>
#> 1 gender   Female    Male           1.6   -0.644 -1.41 0.879       0.348
#> 2 gender   Male      Female         0.625  0.644  1.41 0.879       0.348
#> # ℹ 2 more variables: odds_ratio <dbl>, p_value_fisher <dbl>
#> 
```
