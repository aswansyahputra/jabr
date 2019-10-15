#' Get administrative area
#'
#' List the administrative area of Jawa Barat.
#'
#' @param level Level of administrative division. Valid values are "subdisctrict" for Kecamatan and "village" for Desa/Kelurahan.
#' @param code_bps BPS code of the upper administrative division. To get "subdistrict" level area, you have to supply the BPS code of the district (Kota/Kabupaten). To get "village" level area, you have to supply the BPS code of the subdistrict (Kecamatan).
#'
#' @importFrom rlang arg_match .data
#' @importFrom glue glue
#' @importFrom httr GET content
#' @importFrom purrr transpose
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate_all distinct select
#'
#' @return A tibble.
#'
#' @examples
#' library(jabr)
#'
#' jabar_district
#'
#' jabr_get_adm(level = "subdistrict", code_bps = "3209")
#'
#' @export
jabr_get_adm <- function(level, code_bps) {
  level <- arg_match(level, values = c("subdistrict", "village"))

  if (!is.character(code_bps)) {
    stop("`code_bps` must be a character.", call. = FALSE)
  }

  if (level == "subdistrict" && nchar(code_bps) != 4) {
    stop("`code_bps` for subdistrict level must be 4 characters.", call. = FALSE)
  }

  if (level == "village" && nchar(code_bps) != 7) {
    stop("`code_bps` village level must be 7 characters.", call. = FALSE)
  }

  level <- switch(level,
    subdistrict = "kecamatan",
    village = "desa"
  )

  glue("https://sig-dev.bps.go.id/restBridging/getwilayahperiode/level/{level}/parent/{code_bps}/periode/20181") %>%
    GET() %>%
    content() %>%
    transpose() %>%
    as_tibble() %>%
    mutate_all(unlist) %>%
    distinct(.data$kode_bps, .keep_all = TRUE) %>%
    select(
      name_bps = .data$nama_bps,
      code_bps = .data$kode_bps,
      name_kemendagri = .data$nama_dagri,
      code_kemendagri = .data$kode_dagri
    )
}
