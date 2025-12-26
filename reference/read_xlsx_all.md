# Read an entire Excel file workbook (using openxlsx functions)

Read an entire Excel file workbook (using openxlsx functions)

## Usage

``` r
read_xlsx_all(
  xlsx_file,
  save2env = FALSE,
  names = "",
  start_row = 1,
  detect_dates = TRUE
)
```

## Arguments

- xlsx_file:

  Path to the xls/xlsx file

- save2env:

  Either TRUE to save each worksheet to the environment or FALSE to
  return a list of worksheets, which can be saved to the environment

- names:

  A vector of character data representing preferred sheet names

- start_row:

  first row to begin looking for data. Empty rows at the top of a file
  are always skipped, regardless of the value of start_row.

- detect_dates:

  If TRUE, attempt to recognise dates and perform conversion.

## Value

If there is more than one worksheet, then a list of data frames that
represent each worksheet. If there is only one worksheet, then a data
frame.

## Examples

``` r
if (FALSE) { # \dontrun{
df_list <- read_xlsx_all("path/to/file.xlsx")
} # }
```
