# Read an entire Excel file workbook (using openxlsx functions)

Read an entire Excel file workbook (using openxlsx functions)

## Usage

``` r
read_xlsx_all(
  xlsxFile,
  save2env = FALSE,
  names = "",
  startRow = 1,
  detectDates = TRUE
)
```

## Arguments

- xlsxFile:

  Path to the xls/xlsx file

- save2env:

  Either TRUE to save each worksheet to the environment or FALSE to
  return a list of worksheets, which can be saved to the environment

- names:

  A vector of character data representing preferred sheet names

- startRow:

  first row to begin looking for data. Empty rows at the top of a file
  are always skipped, regardless of the value of startRow.

- detectDates:

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
