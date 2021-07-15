# setup -------------------------------------------------------------------
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, here, jsonlite)


# data import -------------------------------------------------------------

df_e1 <- fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>% 
  purrr::map_dfr(readr::read_csv)

df_ques <- df_e1 %>% 
  dplyr::filter(task == 'bis_bas') %>% 
  dplyr::select(tempID, response) %>% 
  dplyr::mutate(purrr::map_dfr(response, jsonlite::fromJSON)) %>% 
  dplyr::select(!response) %>% 
  tidyr::pivot_longer(cols = starts_with("Q"), 
                      names_to = 'q_id', 
                      names_pattern = "Q([0-9]+)",
                      names_transform = list(q_id = as.numeric)) 


df_items <- list(bis = c(13, 10, 15, 6, 20, 18, 1),
                   drive = c(7, 2, 9, 17),
                   responsive = c(11, 19, 5, 14, 3),
                   seek = c(8, 12, 4, 16)) %>% 
  purrr::map(~data.frame(q_id = .x - 1)) %>% 
  dplyr::bind_rows(.id = "fct_nm")

dplyr::left_join(df_ques, df_items, by = "q_id") %>% 
  dplyr::group_by(tempID, fct_nm) %>% 
  dplyr::summarise(score = sum(value))
