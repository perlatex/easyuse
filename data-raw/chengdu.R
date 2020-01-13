## code to prepare `chengdu` dataset goes here

#usethis::use_data("chengdu")
chengdu <-
  readxl::read_excel('chengdu.xlsx')
usethis::use_data(chengdu, overwrite = TRUE)
