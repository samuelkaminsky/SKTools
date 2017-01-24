#' Read tabular object from clipboard on a Mac
#'
#' @description NOTE THAT I DID NOT WRITE THIS CODE, IT COMES FROM https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @param istable Either TRUE if clipboard object is a tablle, or FALSE if object is a vector
#' @return Table object
#' @export

read.clip.mac <-
  function(istable = TRUE) {
    if (isTRUE(istable)) {
      utils::read.table(pipe("pbpaste"), sep = "\t", header = TRUE) # for a data frame
    }
    else{
      as.vector(unlist(utils::read.table(
        pipe("pbpaste"), sep = "\t", header = FALSE
      )))
    }
  }