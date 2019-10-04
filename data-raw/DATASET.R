## code to prepare `jabr_adm` dataset goes here

library(httr)
library(tidyverse)

get_adm <- function(level, bps_code) {
  level <- match.arg(level, choices = c("kabupaten", "kecamatan", "desa"))

  bps_url <- glue::glue("https://sig-dev.bps.go.id/restBridging/getwilayahperiode/level/{level}/parent/{bps_code}/periode/20181")

  bps_url %>%
    GET %>%
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
    mutate_if(is.character, ~ str_to_title(.x))
}

jabr_district <- get_adm(level = "kabupaten", bps_code = 32)

usethis::use_data(jabr_district, overwrite = TRUE)
