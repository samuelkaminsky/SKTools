#' Sets working directory to current script's location
#' @export
#' @description Sets working directory to current script's location

setwd_script <- function() {
  location <- 
    rstudioapi::getSourceEditorContext()
  slash <- 
    stringr::str_locate_all(location$path, "/") %>% 
    unlist
  slash.last <- length(slash)
  wd <- stringr::str_sub(location$path, start = 1, slash[slash.last])
  setwd(wd)
}