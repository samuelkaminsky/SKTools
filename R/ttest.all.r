#' Conduct T-Tests at every nth percentile for list of IVs and DVs
#' @param df Dataframe with test data
#' @param ivs Names of indepndent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct T-Test at
#' @return Data frame of tidy t.test results
#' @description Conduct T-Tests at every 5% interval for list of IVs and DVs
#' @export

ttest.all <-
  function(df,ivs,dvs,perc=.05) {
    dvs <- dplyr::enquo(dvs)
    ivs <- dplyr::enquo(ivs)
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
            stats::quantile(df[,x] %>% unlist,seq(from=0.05,to=.95,by=perc),na.rm=TRUE) %>%
              as.list() %>%
              purrr::map_df(
                purrr::possibly(
                  function(z){
                df$Grouped <-
                  dplyr::if_else(df[, x] >= z, 1, 0) %>% 
                  as.factor()
                
                testval<<-class(df$Grouped)
                
                cd <-
                  effsize::cohen.d(stats::as.formula(paste0(y," ~ Grouped")),data=df)
                
                cd.df <-
                  data.frame(
                    cd.est = cd$estimate %>% as.numeric(),
                    cd.mag = cd$magnitude %>% as.character()
                  )

                stats::t.test(stats::as.formula(paste0(y," ~ Grouped")),data=df) %>%
                  broom::tidy() %>%
                  cbind(df %>% 
                          dplyr::group_by_(c("Grouped",y)) %>% 
                          dplyr::summarize(Count=dplyr::n()) %>% 
                          dplyr::group_by(Grouped) %>% 
                          dplyr::summarize(Count=sum(Count)) %>% 
                          tidyr::spread(Grouped,Count),
                        Cutoff.Num = z,
                        cd.df)

              }
      ,otherwise = tibble::data_frame(
        estimate = NA_real_,
        estimate1 = NA_real_,
        estimate2 = NA_real_,
        statistic = NA_real_,
        p.value = NA_real_,
        parameter = NA_real_,
        conf.low = NA_real_,
        conf.high = NA_real_,
        method = NA_character_,
        alternative = NA_character_,
        `0` = NA_real_,
        `1` = NA_real_,
        Cutoff.Num = NA_real_,
        Cutoff.Perc = NA_real_,
        cd.est = NA_real_,
        cd.mag = NA_character_
      ))
      ,
              .id="Cutoff.Perc"
              )
          },.id="DV")
      },.id="IV") %>%
      dplyr::distinct() %>%
      tidyr::drop_na(estimate) %>% 
      dplyr::mutate(sig=dplyr::if_else(p.value < .05,TRUE,FALSE)) %>%
      dplyr::mutate_at(vars(estimate:conf.high, Cutoff.Num), funs(round(., 6))) %>%
      dplyr::distinct(IV, DV, estimate, estimate1, .keep_all = TRUE) %>% 
      dplyr::select(IV,DV,Cutoff.Perc,Cutoff.Num,dplyr::everything())
  }
