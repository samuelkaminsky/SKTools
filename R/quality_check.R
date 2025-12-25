#' Checks quality of data in a data frame
#'
#' @param df name of dataframe
#' @author Eric Knudsen <eknudsen88@gmail.com>
#' @return Prints message that identifies columns with no variance and those with strong or moderate skewness.
#' @export

quality_check <- function(df) {
  classes <- sapply(df, class) # get classes of all columns
  num_cols <- df[, which(classes == "integer")]
  same <- apply(df, 2, \(x) {
    if (length(unique(x)) == 1) {
      return(1)
    } else {
      return(0)
    }
  })
  message(".........NO VARIANCE.........")
  message(paste(names(df)[which(same == 1)], collapse = ", "))
  skews <- apply(num_cols, 2, moments::skewness)
  skews <- skews[!is.na(skews)]
  high_neg <- names(skews)[which(skews < -1)]
  high_pos <- names(skews)[which(skews > 1)]
  mod_neg <- names(skews)[which(skews < -0.5 & skews > -1)]
  mod_pos <- names(skews)[which(skews > 0.5 & skews < 1)]
  message("\n.........SKEWNESS.........")
  message(paste("Strong (-): ", paste(high_neg, collapse = ", "), sep = ""))
  message(paste("Strong (+): ", paste(high_pos, collapse = ", "), sep = ""))
  message(paste("Moderate (-): ", paste(mod_neg, collapse = ", "), sep = ""))
  message(paste("Moderate (+): ", paste(mod_pos, collapse = ", "), sep = ""))
}
