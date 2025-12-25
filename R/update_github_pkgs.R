#' Update Packages from Github
#' @export
#' @description Updates packages that have been installed from public Github repositories

update_github_pkgs <- function() {
  check <- "SKTools" %in% .packages()
  if (check) {
    detach("package:SKTools", unload = TRUE)
  }
  utils::installed.packages() |>
    tibble::as_tibble() |>
    dplyr::pull("Package") |>
    purrr::set_names() |>
    purrr::map(utils::packageDescription) |>
    purrr::map(\(x) paste0(x$GithubUsername, "/", x$GithubRepo)) |>
    purrr::map_if(
      \(x) nchar(x) > 3,
      purrr::safely(\(x) devtools::install_github(x))
    )
  if (check) {
    library("SKTools")
  }
}
