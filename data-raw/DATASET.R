## code to prepare `jabr_adm` dataset goes here

library(httr)
library(tidyverse)

jabr_district <-
  bps_response %>%
  content() %>%
  transpose() %>%
  as_tibble() %>%
  mutate_all(~ unlist(.x)) %>%
  distinct(kode_bps, .keep_all = TRUE) %>%
  select(
    name_bps = nama_bps,
    code_bps = kode_bps,
    name_kemendagri = nama_dagri,
    code_kemendagri = kode_dagri
  ) %>%
  mutate_if(is.character, str_to_title)

usethis::use_data(jabr_district, overwrite = TRUE)
