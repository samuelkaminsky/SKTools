#' Read an entire Excel file workbook
#'
#' @param path Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or FALSE to return a list of worksheets, which can be saved to the environment
#' @param names A vector of character data representing preferred sheet names
#' @return If there is more than one worksheet, then a list of data frames that represent each worksheet. If there is only one worksheet, then a data frame.
#' @export


read.xlsx.all <-
  function(path,
           save2env = FALSE,
           names = "") {
    sheetnames <- openxlsx::getSheetNames(path)
    if (length(sheetnames) == 1) {
      worksheet <- openxlsx::read.xlsx(path)
    } else{
      make.sheetnames <- make.names(sheetnames, unique = TRUE)
      workbook <-
        pbapply::pblapply(sheetnames, function(x)
          openxlsx::read.xlsx(path, sheet = x))
      if (sum(names != "") > 0) {
        names(workbook) <- names
      } else {
        names(workbook) <- make.sheetnames
      }
      if (isTRUE(save2env)) {
        list2env(workbook, .GlobalEnv)
      }
      else{
        workbook
      }
    }
  }
