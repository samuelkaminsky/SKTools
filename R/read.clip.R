#' Read object from clipboard
#'
#' @description NOTE THAT I DID NOT WRITE THIS CODE, IT HAS BEEN ADAPTED FROM https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @param istable Either TRUE if clipboard object is a tablle, or FALSE if object is a vector
#' @return Table object
#' @export

read.clip <-
  function(istable = TRUE) {
    if (.Platform$OS.type == "unix") {
      if (isTRUE(istable)) {
        utils::read.table(pipe("pbpaste"), sep = "\t", header = TRUE)
      }
      else{
        as.vector(unlist(utils::read.table(
          pipe("pbpaste"), sep = "\t", header = FALSE
        )))
      }
    }
    if (.Platform$OS.type == "windows") {
      if (isTRUE(istable)) {
        utils::read.table("clipboard", sep = "\t", header = TRUE)
      }
      else{
        readClipboard()
      }
    }
  }
