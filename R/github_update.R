#' Update Packages from Github
#' @export
#' @description Updates packages that have been installed from Github

github_update <- function() {
  installed.packages() %>%
    tibble::as_tibble() %>%
    .$Package %>%
    purrr::set_names()  %>%
    purrr::map(packageDescription) %>%
    purrr::map( ~ paste0(.$GithubUsername, "/", .$GithubRepo)) %>%
    purrr::walk(purrr::safely( ~ devtools::install_github(.)))
}
