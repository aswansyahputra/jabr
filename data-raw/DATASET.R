## code to prepare `jabar_district` dataset goes here

library(httr)
library(tidyverse)

jabar_district <-
  GET("https://sig-dev.bps.go.id/restBridging/getwilayahperiode/level/kabupaten/parent/32/periode/20181") %>%
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

usethis::use_data(jabar_district, overwrite = TRUE)

## code to prepare `jabar_basemap` dataset goes here

library(sf)
library(tidyverse)
load("data/jabar_district.rda")

temp_basemap <- st_read("~/Downloads/BatasWilayah25K(1)/zipfolder/Batas_Wilayah_Administrasi__Area_.shp")

jabar_basemap <-
  temp_basemap %>%
  mutate_if(is.factor, as.character) %>%
  dplyr::filter(WADMPR == "Jawa Barat") %>%
  group_by(district = WADMKK) %>%
  summarise() %>%
  left_join({
    jabr_district %>%
      mutate(
        name = str_remove_all(name_kemendagri, "Kab\\. "),
        name = recode(name, "Kota Cimahi" = "Cimahi")
      )
  }, by = c("district" = "name")) %>%
  select(-district)

usethis::use_data(jabar_basemap, overwrite = TRUE)
