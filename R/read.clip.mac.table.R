#' Read tabular object from clipboard on a Mac
#'
#' @description NOTE THAT I DID NOT WRITE THIS CODE, IT COMES FROM https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @return Table object
#' @export

read.clip.mac.table <-
  function() {
    read.table(pipe("pbpaste"), sep = "\t", header = TRUE) # for a data frame
  }