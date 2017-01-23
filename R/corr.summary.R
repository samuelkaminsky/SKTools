#' Clean corr.test output
#' @param corr.test.results corr.test object
#' @return Dataframe with clean output
#' @export
#' @description Converts corr.test output to single dataframe with most important information (IV, DV, r, n, t, p)

corr.summary <- function(corr.test.results) {
  cor.df <-
    dplyr::bind_cols(lapply(corr.test.results[1:4], function(x) {
      tidyr::gather(tibble::rownames_to_column(as.data.frame(x)), key = rowname)
    }))
  cor.df <- cor.df[, c(1:3, 6, 9, 12)]
  names(cor.df) <- c("IV", "DV", "r", "n", "t", "p")
  dplyr::mutate(cor.df, Sig = ifelse(p < .05, 1, 0))
}