# Install commonly used packages

Installs packages that I like

## Usage

``` r
install_sk(extra = FALSE, dependencies = FALSE)
```

## Arguments

- extra:

  TRUE or FALSE to indicate whether you want to install supplemental
  packages

- dependencies:

  TRUE or FALSE to indicate whether you want to pass TRUE to the
  install.packages() dependencies argument

## Details

Packages installed with the default arguments include:

- clipr

- data.table

- knitr

- lavaan

- openxlsx

- pander

- psych

- rmarkdown

- roxygen2

- shiny

- sjmisc

- sjlabelled

- tidyverse

- writexl

Packages installed with the extra=TRUE argument include:

- anytime

- car

- caret

- doParallel

- DT

- ez

- dtplyr

- effsize

- foreach

- formatR

- GGally

- ggthemes

- googlesheets

- gtools

- iopsych

- janitor

- lmerTest

- lsr

- multilevel

- nycflights13

- parallel

- parsedate

- pdftools

- plotly

- qualtRics

- relaimpo

- reprex

- reshape2

- semTools

- shinythemes

## Examples

``` r
if (FALSE) { # \dontrun{
install_sk()
} # }
```
