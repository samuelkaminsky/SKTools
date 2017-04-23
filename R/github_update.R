#' Update Packages from Github
#' @export
#' @description Updates packages that have been installed from Github

github_update <- function() {
  utils::installed.packages() %>%
    tibble::as_tibble() %>%
    .$Package %>%
    purrr::set_names()  %>%
    purrr::map(utils::packageDescription) %>%
    purrr::map( ~ paste0(.$GithubUsername, "/", .$GithubRepo)) %>%
    purrr::map_if(nchar(.) > 3, purrr::safely( ~ devtools::install_github(.)))
  if ("SKTools" %in% loadedNamespaces()) {
    unloadNamespace("SKTools")
    library(SKTools)
  }
}
