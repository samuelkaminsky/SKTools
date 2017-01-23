#' Read an entire Excel file workbook (using readxl functions)
#'
#' @param path Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or FALSE to return a list of worksheets, which can be saved to the environment
#' @param make.variable.names Either TRUE to make variable names syntactically valid or FALSE to preserve original names
#' @param names A vector of character data representing preferred sheet names
#' @param skip Number of rows to skip when reading in data
#' @return If there is more than one worksheet, then a list of data frames that represent each worksheet. If there is only one worksheet, then a data frame.
#' @export


read_excel_all <-
  function(path,
           save2env = FALSE,
           make.variable.names = TRUE,
           names = "",skip=0) {
    sheetnames <- readxl::excel_sheets(path)
    if (length(readxl::excel_sheets(path)) == 1) {
      worksheet <- readxl::read_excel(path,skip=skip)
      if (isTRUE(make.variable.names)) {
        names(worksheet) <-  make.names(names(worksheet))
        worksheet
      } else {
        worksheet
      }
    } else{
      make.sheetnames <- make.names(sheetnames, unique = TRUE)
      workbook <-
        lapply(sheetnames, function(x)
          readxl::read_excel(path, sheet = x,skip))
      if (sum(names != "") > 0) {
        names(workbook) <- names
      } else {
        names(workbook) <- make.sheetnames
      }
      if (isTRUE(make.variable.names)) {
        for (i in 1:length(sheetnames)) {
          names(workbook[[i]]) <-
            make.names(names(workbook[[i]]), unique = TRUE)
        }
      }
      if (isTRUE(save2env)) {
        list2env(workbook, .GlobalEnv)
      }
      else{
        workbook
      }
    }
  }