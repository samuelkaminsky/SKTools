#' Write object to clipboard
#'
#' @param object R object
#' @description Function to write from the clipboard on Unix and Windows computers. Note that much of this code has been modified from https://tonyladson.wordpress.com/2015/05/20/writing-to-the-clipboard-mac/
#' @return Table pasted to clipboard

write_clip <- function(object) {
  if (.Platform$OS.type == "unix") {
    clip <- pipe("pbcopy", "w")
    utils::write.table(object,
                       file = clip,
                       sep = "\t",
                       row.names = FALSE)
    close(clip)
  }
  if (.Platform$OS.type == "windows") {
    utils::write.table(
      object,
      "clipboard",
      sep = "\t",
      row.names = FALSE
    )
  }
}