# setup -------------------------------------------------------------------

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, here, jsonlite)


# data import -------------------------------------------------------------

df_e1 <- fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>% 
  purrr::map_dfr(readr::read_csv, na = c("", "NA", "null"))


# demography --------------------------------------------------------------

df_subj <- df_e1 %>% 
  dplyr::distinct(tempID, age, sex)

# analyze the data as you like

# flanker -----------------------------------------------------------------

df_flanker <- df_e1 %>% 
  dplyr::filter(task == "flanker_main") %>% 
  dplyr::select(tempID, condition, rt, correct)

# analyze the data as you like
# about functions below, see https://blog.atusy.net/2018/11/09/binwdith-for-geom-histogram/
bw = function(x, f) ceiling((max(x) - min(x)) / f(x))
scott = function(x) bw(x, nclass.scott)
df_flanker %>% 
  dplyr::mutate(cond = dplyr::recode(condition, 一致 = "cong", 中性 = "neu", 不一致 = "incong")) %>% 
  ggplot(aes(x = rt)) +
  geom_histogram(stat = "bin", binwidth = scott) +
  facet_grid(rows = vars(cond), cols = vars(correct))


# BIS/BAS -----------------------------------------------------------------

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
  purrr::map(~data.frame(q_id = .x)) %>% 
  dplyr::bind_rows(.id = "fct_nm")

df_bisbas <- dplyr::left_join(df_ques, df_items, by = "q_id") 

# analyze the data as you like
df_bisbas %>% 
  dplyr::group_by(tempID, fct_nm) %>% 
  dplyr::summarise(score = mean(value))
