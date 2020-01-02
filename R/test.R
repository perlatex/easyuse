library(tidyverse)
library(readxl)


df <- read_excel("../data/girl_data_zk-dy.xlsx")



df %>%
  get_ran_vals(
    .var_school = school,
    .var_class = bj,
    .var_score_pre = score_pre,
    .var_score_after = score_after,
    effects = "class"
  )
