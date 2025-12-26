#' Read an entire Excel file workbook (using openxlsx functions)
#'
#' @param xlsx_file Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or
#' FALSE to return a list of worksheets, which can be saved to the environment
#' @param names A vector of character data representing preferred sheet names
#' @param start_row first row to begin looking for data. Empty rows at the top
#' of a file are always skipped, regardless of the value of start_row.
#' @param detect_dates If TRUE, attempt to recognise dates and perform
#'   conversion.
#' @return If there is more than one worksheet, then a list of data frames that
#' represent each worksheet. If there is only one worksheet, then a data frame.
#' @export
#' @examples
#' \dontrun{
#' df_list <- read_xlsx_all("path/to/file.xlsx")
#' }
read_xlsx_all <-
  function(
    xlsx_file,
    save2env = FALSE,
    names = "",
    start_row = 1,
    detect_dates = TRUE
  ) {
    sheetnames <- openxlsx::getSheetNames(xlsx_file)
    if (length(sheetnames) == 1) {
      openxlsx::read.xlsx(
        xlsxFile = xlsx_file,
        detectDates = detect_dates,
        check.names = TRUE,
        startRow = start_row
      )
    } else {
      make_sheetnames <- make.names(sheetnames, unique = TRUE)
      workbook <-
        lapply(sheetnames, \(x) {
          openxlsx::read.xlsx(
            xlsxFile = xlsx_file,
            sheet = x,
            detectDates = detect_dates,
            check.names = TRUE,
            startRow = start_row
          )
        })
      if (sum(names != "") > 0) {
        names(workbook) <- names
      } else {
        names(workbook) <- make_sheetnames
      }
      if (isTRUE(save2env)) {
        list2env(workbook, .GlobalEnv)
      } else {
        workbook
      }
    }
  }
