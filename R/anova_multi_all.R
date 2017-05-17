#' Conducts One-Way ANOVAs on Multiple DVs at Multiple Cut Points
#' @param df Dataframe with test data
#' @param ivs Names of independent variables to be inserted into dplyr::select()
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @return Data frame of tidy ANOVA post-hoc results, also prints Ns and percentages in each level of the IV
#' @description Conduct one-way ANOVAs on multipe DVs
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
                  purrr::map_df(# possibly(
                    function(a) {
                      df$Grouped <-
                        dplyr::case_when(df[, x] < z ~ 0,
                                         df[, x] >= z &
                                           df[, x] < a ~ 1,
                                         df[, x] >= a ~ 2) %>%
                        as.factor()
                      
                      results.anova <-
                        DVs %>%
                        purrr::map(~ aov(lm(as.formula(
                          paste0("df$`", ., "` ~ df$Grouped")
                        )))) %>%
                        purrr::map_df(broom::tidy, .id = "DV") %>%
                        dplyr::filter(.data$term != "Residuals") %>%
                        dplyr::select(-.data$term)
                      
                      results.posthocs <-
                        DVs %>%
                        purrr::map( ~ aov(lm(as.formula(
                          paste0("df$`", ., "` ~ df$Grouped")
                        )))) %>%
                        purrr::map(stats::TukeyHSD) %>%
                        purrr::map( ~ .[1]) %>%
                        purrr::map(as.data.frame) %>%
                        purrr::map_df(tibble::rownames_to_column, .id =
                                        "DV") %>%
                        tidyr::spread_(key_col = "rowname", value_col =
                                         "df.Grouped.p.adj") %>%
                        dplyr::select(-(dplyr::starts_with("df.Grouped")))  %>%
                        dplyr::group_by(.data$DV) %>%
                        dplyr::summarise_all(dplyr::funs(mean(., na.rm = TRUE)))
                      
                      results <-
                        results.anova %>%
                        dplyr::left_join(results.posthocs,
                                         by = "DV",
                                         na_matches = "never")
                      
                      means <-
                        df %>% 
                        dplyr::group_by(.data$Grouped) %>%
                        dplyr::summarise_at(dplyr::vars(disp, mpg), dplyr::funs(mean(., na.rm = TRUE), n())) %>%
                        gather(Type, Value,-Grouped) %>%
                        separate(Type, c("DV", "Type"), sep = "_") %>%
                        unite(Grouped, .data$Type, .data$Grouped) %>%
                        spread(Grouped, Value)
                      
                      # means.t <-
                      #   means[, -1] %>%
                      #   t() %>%
                      #   as.data.frame() %>%
                      #   purrr::set_names(means[, 1] %>%
                      #                      unlist()) %>%
                      #   tibble::rownames_to_column(var = "DV")
                      
                      df.summary <-
                        cbind(means,
                              p.value = results[, 7:ncol(results)]) %>%
                        as.data.frame() %>%
                        dplyr::mutate_if(is.numeric, dplyr::funs(round(., 4)))
                    }
                    # ,
                    # otherwise = tibble::data_frame(
                    #   estimate = NA_real_,
                    #   estimate1 = NA_real_,
                    #   estimate2 = NA_real_,
                    #   statistic = NA_real_,
                    #   p.value = NA_real_,
                    #   parameter = NA_real_,
                    #   conf.low = NA_real_,
                    #   conf.high = NA_real_,
                    #   method = NA_character_,
                    #   alternative = NA_character_,
                    #   `0` = NA_real_,
                    #   `1` = NA_real_,
                    #   Cutoff.Num = NA_real_,
                    #   Cutoff.Perc = NA_real_,
                    #   cd.est = NA_real_,
                    #   cd.mag = NA_character_
                    # )
                    # )
                    ,
                    .id = "Cutoff.Top")
              }, .id = "Cutoff.Bottom")
          }, .id = "DV")
      }, .id = "IV") %>%
      dplyr::distinct() %>%
      dplyr::mutate_at(vars(starts_with("Cutoff")), funs(parse_number(.)/100)) %>%
      dplyr::filter(.data$Cutoff.Bottom < .data$Cutoff.Top) %>% 
      dplyr::select(
        .data$IV,
        .data$DV,
        .data$Cutoff.Bottom,
        .data$Cutoff.Top,
        .data$mean_0,
        .data$mean_1,
        .data$mean_2,
        .data$n_0,
        .data$n_1,
        .data$n_2,
        .data$`p.value.1-0`,
        .data$`p.value.2-0`,
        .data$`p.value.2-1`
      ) 
  }