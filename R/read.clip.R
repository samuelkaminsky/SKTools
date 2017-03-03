#' Read object from clipboard
#'
#' @description Function to read from the clipboard on Unix and Windows computers. Note that much of this code has been from  https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @param istable Either TRUE if clipboard object is a tablle, or FALSE if object is a vector
#' @param row.names Either TRUE if the clipboard object contains row.names or FALSE if it does not
#' @return Table object
#' @export

read.clip <-
  function(istable = TRUE) {
    if (.Platform$OS.type == "unix") {
      if (isTRUE(istable)) {
        utils::read.delim(pipe("pbpaste"))
      } else{
        as.vector(unlist(utils::read.table(
          pipe("pbpaste"), sep = "\t", header = FALSE
        )))
      }
    } else{
      if (.Platform$OS.type == "windows") {
        if (isTRUE(istable)) {
          utils::read.delim("clipboard")
        } else{
          readClipboard()
        }
      }
    }
  }
