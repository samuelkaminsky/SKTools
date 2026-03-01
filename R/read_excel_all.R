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

    # Single sheet case
    if (length(sheetnames) == 1) {
      res <- readxl::read_excel(path = path, skip = skip)
      if (isTRUE(check_names)) {
        names(res) <- make.names(names(res), unique = TRUE)
      }
      return(res)
    }

    # Multiple sheets case
    res_list <-
      purrr::map(
        sheetnames,
        \(x) readxl::read_excel(path = path, sheet = x, skip = skip)
      )

    # Clean column names if requested
    if (isTRUE(check_names)) {
      res_list <-
        purrr::map(
          res_list,
          \(x) purrr::set_names(x, make.names(names(x), unique = TRUE))
        )
    }

    # Set sheet names
    if (all(names != "") && length(names) == length(sheetnames)) {
      names(res_list) <- names
    } else {
      names(res_list) <- make.names(sheetnames, unique = TRUE)
    }

    if (isTRUE(save2env)) {
      list2env(res_list, envir = .GlobalEnv)
    } else {
      res_list
    }
  }
