# setup -------------------------------------------------------------------

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, here, jsonlite)


# data import -------------------------------------------------------------

df_e1 <- fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>% 
  purrr::map_dfr(readr::read_csv, na = c("", "NA", "null"))


# demography --------------------------------------------------------------

df_subj_e1 <- df_e1 %>% 
  dplyr::distinct(tempID, age, sex)

# analyze the data as you like
df_subj_e1 %>% 
  dplyr::mutate(sex_c = dplyr::recode(sex, 男性 = 1, 女性 = 0)) %>% 
  dplyr::summarise(mean_age = mean(age), sd_age = sd(age), n_male = sum(sex_c))

# flanker -----------------------------------------------------------------

df_flanker_e1 <- df_e1 %>% 
  dplyr::filter(task == "flanker_main") %>% 
  dplyr::select(tempID, condition, rt, correct)

# analyze the data as you like
summary(df_flanker_e1)

# proportion of correct responses
df_flanker_e1 %>% 
  dplyr::group_by(tempID, condition) %>% 
  dplyr::summarise(p_corr = mean(correct))

# mean and median of RTs of correct and incorrect responses
df_flanker_e1 %>% 
  dplyr::group_by(tempID, condition, correct) %>% 
  dplyr::summarise(mean_rt = mean(rt), med_rt = median(rt))

# visualize
# about functions below, see https://blog.atusy.net/2018/11/09/binwdith-for-geom-histogram/
bw = function(x, f) ceiling((max(x) - min(x)) / f(x))
scott = function(x) bw(x, nclass.scott)
df_flanker_e1 %>% 
  dplyr::filter(rt < 10000) %>% # remove outlier
  dplyr::mutate(cond = dplyr::recode(condition, 一致 = "cong", 中性 = "neu", 不一致 = "incong")) %>% 
  ggplot(aes(x = rt)) +
  geom_histogram(stat = "bin", binwidth = scott) +
  facet_grid(rows = vars(cond), cols = vars(correct))


# BIS/BAS -----------------------------------------------------------------

df_items_e1 <- list(bis = c(13, 10, 15, 6, 20, 18, 1),
                    drive = c(7, 2, 9, 17),
                    responsive = c(11, 19, 5, 14, 3),
                    seek = c(8, 12, 4, 16)) %>% 
  purrr::map_dfr(~data.frame(q_id = .x), .id = "fct_nm")

items_rev <- c(1, 18) # ids of reversed items

df_bisbas_e1 <- df_e1 %>% 
  dplyr::filter(task == 'bis_bas') %>% 
  dplyr::select(tempID, response) %>%
  dplyr::mutate(purrr::map_dfr(response, jsonlite::fromJSON)) %>% 
  dplyr::select(!response) %>% 
  tidyr::pivot_longer(cols = starts_with("Q"), 
                      names_to = 'q_id', 
                      names_pattern = "Q([0-9]+)",
                      names_transform = list(q_id = as.numeric)) %>% 
  dplyr::left_join(df_items_e1, by = "q_id") %>% 
  dplyr::mutate(value = value + 1, # convert 0 ~ 3 (default scoring by jsPsych) to 1 ~ 4
                value = if_else(q_id %in% items_rev, 5 - value, value)) # deal with reversed items

# analyze the data as you like
df_bisbas_e1 %>% 
  dplyr::group_by(tempID, fct_nm) %>% 
  dplyr::summarise(score = mean(value))
