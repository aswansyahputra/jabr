#' Get administrative area
#'
#' List the administrative area in Jawa Barat.
#'
#' @param level Level of administrative division. Valid values are "district" for Kota/Kabupaten, "subdistrict" for Kecamatan and "village" for Desa/Kelurahan.
#' @param code_bps BPS code of the upper administrative division. Note that BPS code for "district" level is "32". To get "subdistrict" level area, you have to supply the BPS code of the district (Kota/Kabupaten). To get "village" level area, you have to supply the BPS code of the subdistrict (Kecamatan).
#'
#' @importFrom rlang arg_match .data
#' @importFrom glue glue
#' @importFrom httr GET http_error content
#' @importFrom purrr transpose
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate_all distinct select
#'
#' @return A tibble.
#'
#' @examples
#' \donttest{
#' library(jabr)
#'
#' jabr_area(level = "district", code_bps = "32")
#'
#' # fetch subdistrict area in Kab. Cirebon
#' jabr_area(level = "subdistrict", code_bps = "3209")
#' }
#'
#' @export
jabr_area <- function(level, code_bps) {
  level <- arg_match(level, values = c("district", "subdistrict", "village"))

  if (!is.character(code_bps)) {
    stop("`code_bps` must be a character.", call. = FALSE)
  }

  if (level == "district" && nchar(code_bps) != 2) {
    stop("`code_bps` for district level must be 2 characters.", call. = FALSE)
  }

  if (level == "district" && code_bps != "32") {
    stop("`code_bps` for district level must be '32'.", call. = FALSE)
  }

  if (level == "subdistrict" && nchar(code_bps) != 4) {
    stop("`code_bps` for subdistrict level must be 4 characters.", call. = FALSE)
  }

  if (level == "village" && nchar(code_bps) != 7) {
    stop("`code_bps` village level must be 7 characters.", call. = FALSE)
  }

  level <- switch(level,
    district = "kabupaten",
    subdistrict = "kecamatan",
    village = "desa"
  )

  resp <- GET(
    glue("https://sig-dev.bps.go.id/restBridging/getwilayahperiode/level/{level}/parent/{code_bps}/periode/20181")
  )

  if (http_error(resp)) {
    stop("Failed to fetch data. Please re-check your supplied arguments!", call. = FALSE)
  }

  res <-
    content(resp) %>%
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

  return(res)
}
