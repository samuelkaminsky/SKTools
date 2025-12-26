[![R-CMD-check.yaml](https://github.com/samuelkaminsky/SKTools/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/samuelkaminsky/SKTools/actions/workflows/check-standard.yaml)
[![codecov](https://codecov.io/gh/samuelkaminsky/SKTools/branch/master/graph/badge.svg)](https://codecov.io/gh/samuelkaminsky/SKTools)

# SKTools
A collection of R functions that help with importing and analyzing data frames.

<b>Install from GitHub</b>:
<ol>
  <li>If not installed already, install <code>remotes</code> package: <code>install.packages("remotes")</code>.</li>
<li>Use <code>remotes::install_github("samuelkaminsky/SKTools")</code> to install the package.</li>

## Usage

```r
library(SKTools)

# Calculate descriptives
descriptives(mtcars)

# Calculate frequencies
frequencies(mtcars)

# Read all sheets from an Excel file
# df_list <- read_excel_all("path/to/file.xlsx")
```

