## code to prepare `basemap_urls` dataset goes here
library(ckanr)
library(tidyverse)

basemap_urls <-
  package_list_current(
    as = "table",
    limit = 9999,
    url = "http://data.jabarprov.go.id"
  ) %>%
  select(.data$resources, .data$author) %>%
  unnest(.data$resources) %>%
  filter(.data$format == "GeoJSON") %>%
  transmute(
    level = case_when(
      .data$name == "Area Jawa Barat" ~ "province",
      .data$name == "Area Kota/Kabupaten" ~ "district",
      .data$name == "Area Kecamatan" ~ "subdistrict",
      .data$name == "Area Kelurahan/Desa" ~ "village",
    ),
    url
  ) %>%
  filter(level != "province") %>%
  deframe()

usethis::use_data(basemap_urls, internal = TRUE)
