# Read an entire Excel file workbook (using readxl functions)

Read an entire Excel file workbook (using readxl functions)

## Usage

``` r
read_excel_all(
  path,
  save2env = FALSE,
  check_names = FALSE,
  names = "",
  skip = 0
)
```

## Arguments

- path:

  Path to the xls/xlsx file

- save2env:

  Either TRUE to save each worksheet to the environment or FALSE to
  return a list of worksheets, which can be saved to the environment

- check_names:

  Either TRUE to make variable names syntactically valid or FALSE to
  preserve original names

- names:

  A vector of character data representing preferred sheet names

- skip:

  Number of rows to skip when reading in data

## Value

If there is more than one worksheet, then a list of data frames that
represent each worksheet. If there is only one worksheet, then a data
frame.

## Examples

``` r
if (FALSE) { # \dontrun{
df_list <- read_excel_all("path/to/file.xlsx")
} # }
```
