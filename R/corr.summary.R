#' Clean corr.test output
#' @param corr.test.results corr.test object
#' @param alpha Alpha level to test significance
#' @return Dataframe with clean output
#' @export
#' @description Converts corr.test output to single dataframe with most important information (IV, DV, r, n, t, p)

corr.summary <- function(corr.test.results,alpha=.05) {
  cor.df =
    dplyr::bind_cols(lapply(corr.test.results[1:4], function(x) {
      reshape2::melt(tibble::rownames_to_column(as.data.frame(x)))
    }))
  cor.df <- cor.df[, c(1:3, 6, 9, 12)]
  names(cor.df) <- c("IV", "DV", "r", "n", "t", "p")
  cor.df$Sig = ifelse(cor.df$p < alpha, 1, 0)
  cor.df
}