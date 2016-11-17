#' Checks quality of data in a data frame
#'
#' @param df name of dataframe
#' @return summary statistics of data frame
#' @export

quality.check <- function(df){

  classes <- sapply(df, class) # get classes of all columns
  num.cols <-  df[,which(classes=="integer")]

  #no variance (only one unique value)
  same <- apply(df, 2, function(x){
            if(length(unique(x)) == 1){
              return(1)
            }
            else{ return(0)}
          })
  message(".........NO VARIANCE.........")
  message(paste(names(df)[which(same == 1)], collapse=", "))

  # skewness standards by Bulmer (1979)
  skews <- apply(num.cols, 2, moments::skewness)
  skews <- skews[!is.na(skews)]
  high.neg <- names(skews)[which(skews < -1)]
  high.pos <- names(skews)[which(skews > 1)]
  mod.neg <- names(skews)[which(skews < -0.5 & skews > -1)]
  mod.pos <- names(skews)[which(skews > 0.5 & skews < 1)]
  message("\n.........SKEWNESS.........")
  message(paste("Strong (-): ",paste(high.neg,collapse=", "),sep=""))
  message(paste("Strong (+): ",paste(high.pos,collapse=", "),sep=""))
  message(paste("Moderate (-): ",paste(mod.neg,collapse=", "),sep=""))
  message(paste("Moderate (+): ",paste(mod.pos,collapse=", "),sep=""))

  # # normality (shapiro-Wilks test)
  # norm.tests <- apply(num.cols, 2, function(x){
  #   col <- na.omit(x)
  #   if(length(col)>3 && length(unique(col))>1){
  #     suppressWarnings(ks.test(col, "pnorm"))}})
  # norm.tests <- norm.tests[-which(unlist(lapply(norm.tests, is.null)))]
  # norm.tests2 <- unlist(lapply(norm.tests,function(x){
  #   x['p.value']
  # }))
  # norm.pvals <- which(norm.tests2 < 0.05)
  # message("\n.........NORMALITY VIOLATIONS.........")
  # message(paste(names(norm.tests)[norm.pvals],collapse=", "))
  }
