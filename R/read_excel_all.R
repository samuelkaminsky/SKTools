#' Read an entire Excel file workbook (using readxl functions)
#'
#' @param path Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or FALSE to return a list of worksheets, which can be saved to the environment
#' @param check.names Either TRUE to make variable names syntactically valid or FALSE to preserve original names
#' @param names A vector of character data representing preferred sheet names
#' @param skip Number of rows to skip when reading in data
#' @return If there is more than one worksheet, then a list of data frames that represent each worksheet. If there is only one worksheet, then a data frame.
#' @export

read_excel_all <-
  function(path, save2env = FALSE, check.names = FALSE, names = "", skip = 0) {
    sheetnames <- readxl::excel_sheets(path)
    if (length(readxl::excel_sheets(path)) == 1) {
      worksheet <- readxl::read_excel(path = path, skip = skip)
      if (isTRUE(check.names)) {
        names(worksheet) <- make.names(names(worksheet), unique = TRUE)
        worksheet
      } else {
        worksheet
      }
    } else {
      make.sheetnames <- make.names(sheetnames, unique = TRUE)
      workbook <-
        lapply(sheetnames, function(x) {
          readxl::read_excel(
            path = path,
            sheet = x,
            skip = skip
          )
        })
      if (sum(names != "") > 0) {
        names(workbook) <- names
      } else {
        names(workbook) <- make.sheetnames
      }
      if (isTRUE(check.names)) {
        for (i in seq_along(sheetnames)) {
          names(workbook[[i]]) <-
            make.names(names(workbook[[i]]), unique = TRUE)
        }
      }
      if (isTRUE(save2env)) {
        list2env(workbook, .GlobalEnv)
      } else {
        workbook
      }
    }
  }
