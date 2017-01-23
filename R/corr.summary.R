#' Clean corr.test output
#' @param corr.test.results corr.test object
#' @return Dataframe with clean output
#' @export
#' @description Converts corr.test output to single dataframe with most important information (IV, DV, r, n, t, p)

corr.summary <- function(corr.test.results) {
  cor.df <-
    lapply(corr.test.results[1:4], function(x) {
      x %>%
        as.data.frame() %>%
        rownames_to_column() %>%
        gather(key = rowname)
    }) %>%
    bind_cols()
  cor.df <- cor.df[, c(1:3, 6, 9, 12)]
  names(cor.df) <- c("IV", "DV", "r", "n", "t", "p")
  mutate(cor.df, Sig = ifelse(p < .05, 1, 0))
}