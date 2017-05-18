#' Conducts One-Way ANOVAs on Multiple DVs at Multiple Cut Points
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @param perc Nth percentile to conduct ANOVA at
#' @return Data frame of tidy ANOVA F test and post-hoc results, also includes descriptives about each level of the IV
#' @description Conduct one-way ANOVAs on multiple DVs at various cutpoints of the iv
#' @export

anova_multi_all <-
  function(df, ivs, dvs, perc = .05) {
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
    summary <-
      
      IVs %>%
      purrr::map_df(function(x) {
        DVs %>%
          purrr::map_df(function(y) {
            stats::quantile(df[, x] %>% unlist, seq(
              from = 0.05,
              to = .95,
              by = perc
            ), na.rm = TRUE) %>%
              as.list() %>%
              purrr::map_df(function(z) {
                stats::quantile(df[, x] %>% unlist, seq(
                  from = 0.05,
                  to = .95,
                  by = perc
                ), na.rm = TRUE) %>%
                  as.list() %>%
                  purrr::map_df(purrr::possibly(function(a) {
                    if(a >= z){
                      df$Grouped <-
                        dplyr::case_when(df[, x] < z ~ 0,
                                         df[, x] >= z &
                                           df[, x] < a ~ 1,
                                         df[, x] >= a ~ 2) %>%
                        as.factor()
                      
                      temp.anova <- stats::aov(stats::lm(stats::as.formula(
                        paste0("df$`", y, "` ~ df$Grouped")
                      )))
                      
                      results.anova <-
                        temp.anova %>%
                        broom::tidy() %>%
                        dplyr::filter(.data$term != "Residuals") %>%
                        dplyr::select(-.data$term) %>%
                        cbind(DV = as.character(y))
                      
                      results.posthocs <-
                        temp.anova %>%
                        stats::TukeyHSD() %>%
                        .[1] %>%
                        as.data.frame() %>%
                        tibble::rownames_to_column() %>%
                        tidyr::spread("rowname","df.Grouped.p.adj") %>%
                        dplyr::select(-(dplyr::starts_with("df.Grouped"))) %>%
                        cbind(DV = as.character(y)) %>%
                        dplyr::group_by(.data$DV) %>%
                        dplyr::summarise_all(dplyr::funs(mean(., na.rm = TRUE)))
                      
                      mean0 <-
                        df %>%
                        dplyr::filter(.data$Grouped == 0) %>%
                        dplyr::select(paste0(y)) %>%
                        unlist() %>%
                        mean(na.rm = TRUE)
                      mean1 <-
                        df %>%
                        dplyr::filter(.data$Grouped == 1) %>%
                        dplyr::select(paste0(y)) %>%
                        unlist() %>%
                        mean(na.rm = TRUE)
                      mean2 <-
                        df %>%
                        dplyr::filter(.data$Grouped == 2) %>%
                        dplyr::select(paste0(y)) %>%
                        unlist() %>%
                        mean(na.rm = TRUE)
                      
                      n <-
                        df %>%
                        dplyr::group_by(.data$Grouped) %>%
                        dplyr::summarize(Count = n()) %>%
                        tidyr::spread("Grouped", "Count")
                      
                      results <-
                        results.anova %>%
                        dplyr::left_join(results.posthocs,
                                         by = "DV",
                                         na_matches = "never") %>%
                        cbind(mean_0 = mean0,
                              mean_1 = mean1,
                              mean_2 = mean2,
                              n) %>% 
                        dplyr::mutate_if(is.factor,dplyr::funs(as.character(.)))
                      return(results)}
                    
                  }, 
                  otherwise = tibble::data_frame(
                    Error="Y"
                  )
                  ), .id = "Cutoff.Top")
              }, .id = "Cutoff.Bottom")
          }, .id = "DV")
      }, .id = "IV") %>% 
      dplyr::distinct() %>%
      dplyr::mutate_at(dplyr::vars(dplyr::starts_with("Cutoff")),
                       dplyr::funs(readr::parse_number(.) / 100)) %>%
      dplyr::filter(.data$Cutoff.Bottom <= .data$Cutoff.Top) %>%
      dplyr::select(
        .data$IV,
        .data$DV,
        .data$Cutoff.Bottom,
        .data$Cutoff.Top,
        .data$df,
        .data$sumsq,
        .data$meansq,
        .data$statistic,
        .data$p.value,
        .data$mean_0,
        .data$mean_1,
        .data$mean_2,
        n_0 = .data$`0`,
        n_1 = .data$`1`,
        n_2 = .data$`2`,
        `p.value.1-0` = .data$`1-0`,
        `p.value.2-0` = .data$`2-0`,
        `p.value.2-1` = .data$`2-1`
      )
    
    percs <-
      df %>%
      purrr::map(unlist) %>%
      purrr::map_df(~ quantile(., seq(0, 1, by = .01))) %>%
      dplyr::mutate(Perc = (0:100) / 100) %>%
      tidyr::gather("iv", "num",-.data$Perc) %>%
      dplyr::distinct()
    
    
    summary %>%
      dplyr::left_join(percs,
                       by = c("IV" = "iv", "Cutoff.Bottom" = "Perc"),
                       na_matches = "never") %>%
      dplyr::left_join(percs,
                       by = c("IV" = "iv", "Cutoff.Top" = "Perc"),
                       na_matches = "never") %>%
      dplyr::select(
        .data$IV:.data$Cutoff.Top,
        Cutoff.Bottom.Num = .data$num.x,
        Cutoff.Top.Num = .data$num.y,
        dplyr::everything()
      ) %>% 
      dplyr::mutate_at(dplyr::vars(dplyr::contains("p.value")),dplyr::funs(round(.,6))) %>% 
      dplyr::mutate_at(dplyr::vars(dplyr::contains("mean_")),dplyr::funs(dplyr::if_else(is.nan(.),NA_real_,.)))
  }