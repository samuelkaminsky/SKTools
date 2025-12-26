#' Read an entire Excel file workbook (using readxl functions)
#'
#' @param path Path to the xls/xlsx file
#' @param save2env Either TRUE to save each worksheet to the environment or
#'   FALSE to return a list of worksheets, which can be saved to the environment
#' @param check_names Either TRUE to make variable names syntactically valid or
#'   FALSE to preserve original names
#' @param names A vector of character data representing preferred sheet names
#' @param skip Number of rows to skip when reading in data
#' @return If there is more than one worksheet, then a list of data frames that
#'   represent each worksheet. If there is only one worksheet, then a data
#'   frame.
#' @export
#' @examples
#' \dontrun{
#' df_list <- read_excel_all("path/to/file.xlsx")
#' }
read_excel_all <-
  function(path, save2env = FALSE, check_names = FALSE, names = "", skip = 0) {
    sheetnames <- readxl::excel_sheets(path)
    if (length(readxl::excel_sheets(path)) == 1) {
      worksheet <- readxl::read_excel(path = path, skip = skip)
      if (isTRUE(check_names)) {
        names(worksheet) <- make.names(names(worksheet), unique = TRUE)
        worksheet
      } else {
        worksheet
      }
    } else {
      make_sheetnames <- make.names(sheetnames, unique = TRUE)
      worksheet <-
        purrr::map(
          sheetnames,
          \(x) readxl::read_excel(path = path, sheet = x, skip = skip)
        )
      if (isTRUE(check_names)) {
        worksheet <-
          worksheet |>
          purrr::map(
            \(x) purrr::set_names(x, make.names(names(x), unique = TRUE))
          )
      }
      if (names != "") {
        names(worksheet) <- names
      } else {
        names(worksheet) <- make_sheetnames
      }
      if (isTRUE(save2env)) {
        list2env(worksheet, .GlobalEnv)
      } else {
        worksheet
      }
    }
  }
