To ensure a smooth and error-free experience when working with this R package, please follow these setup instructions carefully.

## Environment Setup

### System Dependencies

Before installing the R packages, you'll need to install several system-level libraries. These are essential for some of the R packages to build correctly.

Run the following command to install the required system dependencies:

```bash
sudo apt-get update && sudo apt-get install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff5-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libpng-dev
```

### R Package Installation

Once the system dependencies are in place, you can install the R packages listed in the `DESCRIPTION` file. It's recommended to install them in smaller batches to avoid timeouts.

First, install the `devtools` package, as it has many dependencies:

```R
install.packages("devtools", repos="https://cran.rstudio.com/")
```

Then, install the remaining packages:

```R
install.packages(c(
    "broom", "dplyr", "effsize", "httr", "jsonlite", "moments",
    "openxlsx", "purrr", "readxl", "rlang", "rstudioapi", "sjlabelled",
    "stringr", "tibble", "tidyr", "testthat", "readr", "psych",
    "pkgdown", "lintr", "rcmdcheck"
), repos="https://cran.rstudio.com/")
```

### Local Package Installation

After installing all the dependencies, you need to install the `SKTools` package itself. From the root of the repository, run the following command:

```bash
sudo R CMD INSTALL .
```

### Running Tests

To verify that everything is set up correctly, run the test suite:

```R
Rscript -e "testthat::test_dir('tests/testthat')"
```

By following these steps, you should be able to create a stable environment for developing and testing the `SKTools` R package.
