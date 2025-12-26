#' Sets working directory to current script's location
#' @export
#' @description Sets working directory to current script's location
#' @examples
#' \dontrun{
#' setwd_script()
#' }
setwd_script <- function() {
  location <- rstudioapi::getSourceEditorContext()
  wd <- dirname(location$path)
  setwd(wd)
}
