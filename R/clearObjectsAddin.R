#' Clear Workspace
#' @export
#' @description Removes all objects from workspace

clearObjectsAddin <- function() {
  rm(list=ls())
}
