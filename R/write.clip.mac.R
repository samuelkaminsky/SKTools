#' Write tabular object to clipboard on a Mac
#'
#' @param object R object
#' @description NOTE THAT I DID NOT WRITE THIS CODE, IT COMES FROM https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @return Table pasted to clipboard
#' @export

write.clip.mac <-
  function(object) {
    clip <- pipe("pbcopy", "w")
    utils::write.table(object, file = clip, sep = '\t')
    close(clip)
  }