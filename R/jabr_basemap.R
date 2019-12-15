#' Get basemap
#'
#' List basemap of the administrative area in Jawa Barat.
#'
#' @param level Level of administrative division. Valid values are "district" for Kota/Kabupaten, "subdistrict" for Kecamatan and "village" for Desa/Kelurahan.
#'
#' @importFrom rlang arg_match .data
#' @importFrom rappdirs user_cache_dir
#' @importFrom glue glue
#' @importFrom ckanr ckan_fetch
#' @importFrom dplyr transmute
#'
#' @return A tibble.
#'
#' @examples
#' \donttest{
#' library(jabr)
#'
#' jabr_basemap(level = "district")
#' }
#'
#' @export
jabr_basemap <- function(level) {
  level <- arg_match(level, values = c("district", "subdistrict", "village"))

  jabr_cache_dir <- user_cache_dir("jabr")
  jabr_basemap_filename <- glue("jabr_basemap_{level}.rda")

  if (!file.exists(file.path(jabr_cache_dir, jabr_basemap_filename))) {
    message("Preparing database, please wait a moment...")
    if (!dir.exists(jabr_cache_dir)) {
      dir.create(jabr_cache_dir)
    }

    res <-
      ckan_fetch(basemap_urls[[level]]) %>%
      transmute(
        name_bps = .data$bps_nama,
        code_bps = .data$bps_kode,
        name_kemendagri = .data$kemendagri_nama,
        code_kemendagri = .data$kemendagri_kode,
        .data$geometry
      )

    save(
      res,
      file = file.path(jabr_cache_dir, jabr_basemap_filename),
      compress = "bzip2",
      compression_level = 9
    )
  }

  load(file = file.path(jabr_cache_dir, jabr_basemap_filename))

  return(res)
}
