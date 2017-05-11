#' Conducts One-Way ANOVAs on Multiple DVs
#' @param df Dataframe with test data
#' @param iv Name of independent variable
#' @param dvs Names of dependent variables to be inserted into dplyr::select()
#' @return List with data frame of tidy t.test results, and Ns and percentages in each level of the IV
#' @description Conduct one-way ANOVAs on multipe DVs
#' @export

anova_multi <-
  function(df, iv, dvs) {
    iv <- dplyr::enquo(iv)
    # iv.r <- paste0(quo_name(iv))
    dvs <- dplyr::enquo(dvs)
    
    df <-
      df %>%
      dplyr::mutate(iv = as.factor(!!iv))
    
    dvs.list <-
      df %>%
      dplyr::select(!!dvs) %>%
      names() %>%
      as.list() %>% 
      purrr::set_names()
    
    results.anova <-
      dvs.list %>% 
      purrr::map(~aov(lm(as.formula(paste0("df$",.," ~ df$iv"))))) %>% 
      purrr::map_df(broom::tidy,.id="DV") %>%
      dplyr::filter(.data$term != "Residuals") %>% 
      dplyr::select(-.data$term)
    
    results.posthocs <-
      dvs.list %>% 
      purrr::map(~aov(lm(as.formula(paste0("df$",.," ~ df$iv"))))) %>% 
      purrr::map(stats::TukeyHSD) %>% 
      purrr::map(~.[1]) %>% 
      purrr::map(as.data.frame) %>% 
      purrr::map_df(tibble::rownames_to_column,.id="DV") %>% 
      tidyr::spread(rowname,df.iv.p.adj) %>% 
      dplyr::select(-(dplyr::starts_with("df.iv")))  %>%
      dplyr::group_by(DV) %>%
      dplyr::summarise_all(dplyr::funs(mean(., na.rm = TRUE))) 
    
    results <- 
      dplyr::left_join(results.anova, results.posthocs,by="DV")
    
    means <- 
      df %>%
      dplyr::group_by(iv) %>%
      dplyr::summarise_at(dplyr::vars(!!dvs), dplyr::funs(mean(., na.rm = TRUE)))
    
    means.t <-
      means[,-1] %>%
      t %>%
      as.data.frame() %>%
      purrr::set_names(means[, 1] %>%
                  unlist()) %>% 
      tibble::rownames_to_column(var = "DV")
    
    summary <-
      cbind(means.t,
            p.value=results[, 7:ncol(results)]) %>% 
      as.data.frame() %>%
      dplyr::mutate_if(is.numeric, dplyr::funs(round(., 4)))
    
    details <- list(
      # IV = iv,
      # SJT.Items = df %>% select(contains("AOSJT")) %>% names,
      Ns = table(df$iv),
      Props = prop.table(table(df$iv)) %>% round(3)
    )
    
    return(list(Summary=summary,Details=details))
  }