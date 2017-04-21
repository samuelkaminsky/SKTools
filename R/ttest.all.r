#' Conduct T-Tests at every nth percentile for list of IVs and DVs
#' @param df Dataframe with test data
#' @param ivs Names of indepndent variables as character string
#' @param dvs Names of dependent variables as character string
#' @param perc Pth percentile
#' @return Data frame of tidy t.test results
#' @description Conduct T-Tests at every 5% interval for list of IVs and DVs
#' @export

ttest.all <-
  function(df,ivs,dvs,perc=.05){
    dvs <- enquo(dvs)
    ivs <- enquo(ivs)
    IVs <-
      df %>%
      dplyr::select(!!ivs) %>%
      names() %>%
      purrr::set_names()
    DVs <-
      df %>%
      dplyr::select(!!dvs) %>%
      names() %>%
      purrr::set_names()
    
    IVs %>%
      purrr::map_df(function(x){
        DVs %>%
          purrr::map_df(function(y){
            stats::quantile(df[,x],seq(0.05,.95,perc),na.rm=TRUE) %>%
              as.list() %>%
              purrr::map_df(purrr::possibly(function(z){
                df$Grouped <-
                  if_else(df[, x] >= z, 1, 0)
                
                
                cd <-
                  effsize::cohen.d(df[, y] ~ df$Grouped)
                
                cd.df <-
                  data.frame(
                    cd.est = cd$estimate %>% as.numeric(),
                    cd.mag = cd$magnitude %>% as.character()
                  )
                
                
                stats::t.test(df[, y] ~ df$Grouped) %>%
                  broom::tidy(.) %>%
                  cbind(table(df$Grouped, df[, y]) %>%
                          rowSums() %>%
                          t %>%
                          as.data.frame(),
                        Value = z,
                        cd.df)
                
              },otherwise = data_frame(Cutoff=NA_real_,cd.est=NA_real_,cd.mag=NA_character_))
              ,
              .id="Cutoff"
              )
          },.id="DV")
      },.id="IV") %>%
      distinct %>%
      mutate(sig=if_else(p.value < .05,TRUE,FALSE)) %>%
      mutate_at(vars(estimate:conf.high, Value), funs(round(., 6))) %>%
      distinct(IV, DV, estimate, estimate1, .keep_all = TRUE)
  }
