#' Read an entire Excel file workbook (using openxlsx functions)
#'
#' @param xlsxFile Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or FALSE to return a list of worksheets, which can be saved to the environment
#' @param names A vector of character data representing preferred sheet names
#' @param startRow first row to begin looking for data. Empty rows at the top of a file are always skipped, regardless of the value of startRow.
#' @param detectDates If TRUE, attempt to recognise dates and perform conversion.
#' @return If there is more than one worksheet, then a list of data frames that represent each worksheet. If there is only one worksheet, then a data frame.
#' @export

read.xlsx.all <-
  function(xlsxFile,
           save2env = FALSE,
           names = "",
           startRow = 1,
           detectDates = TRUE) {
    sheetnames <- openxlsx::getSheetNames(xlsxFile)
    if (length(sheetnames) == 1) {
      worksheet <-
        openxlsx::read.xlsx(
          xlsxFile = xlsxFile,
          detectDates = detectDates,
          check.names = TRUE,
          startRow = startRow
        )
    } else {
      make.sheetnames <- make.names(sheetnames, unique = TRUE)
      workbook <-
        lapply(sheetnames, function(x) {
          openxlsx::read.xlsx(
            xlsxFile = xlsxFile,
            sheet = x,
            detectDates = detectDates,
            check.names = TRUE,
            startRow = startRow
          )
        })
      if (sum(names != "") > 0) {
        names(workbook) <- names
      } else {
        names(workbook) <- make.sheetnames
      }
      if (isTRUE(save2env)) {
        list2env(workbook, .GlobalEnv)
      }
      else {
        workbook
      }
    }
  }
