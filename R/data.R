#' Administrative area of Jawa Barat
#'
#' A list of district area (Kota/Kabupaten) in Jawa Barat.
#'
#' @format A tibble with 27 rows and 4 columns.
#' \describe{
#'   \item{name_bps}{Name of the area according to BPS}
#'   \item{code_bps}{Code of the area according to BPS}
#'   \item{name_kemendagri}{Name of the area according to KEMENDAGRI}
#'   \item{code_kemendagri}{Code of the area according to KEMENDAGRI}
#' }
#'
#' @examples
#' library(jabr)
#'
#' jabar_district
"jabar_district"

#' Basemap of Jawa Barat
#'
#' Map of district area (Kota/Kabupaten) in Jawa Barat.
#' @format An sf object with 27 features and 4 fields.
#' \describe{
#'   \item{name_bps}{Name of the area according to BPS}
#'   \item{code_bps}{Code of the area according to BPS}
#'   \item{name_kemendagri}{Name of the area according to KEMENDAGRI}
#'   \item{code_kemendagri}{Code of the area according to KEMENDAGRI}
#' }
#'
"jabar_basemap"
