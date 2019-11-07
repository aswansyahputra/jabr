#' List Dataset
#'
#' List the dataset available at Open Data Jawa Barat.
#'
#' @param update (logical) Whether to update the dataset list.
#'
#' @importFrom rlang .data
#' @importFrom rappdirs user_cache_dir
#' @importFrom ckanr package_list_current
#' @importFrom dplyr select transmute na_if
#' @importFrom tidyr unnest
#' @importFrom stringr str_extract str_replace_all str_remove_all
#' @importFrom tools toTitleCase
#'
#' @return A tibble.
#'
#' @examples
#' \donttest{
#' library(jabr)
#'
#' jabr_list_dataset()
#'
#' }
#' @export
jabr_list_dataset <- function(update = FALSE) {
  jabr_cache_dir <- user_cache_dir("jabr")

  if (!file.exists(file.path(jabr_cache_dir, "jabr_data.rda")) |
    update) {
    if (!dir.exists(jabr_cache_dir)) {
      message("Preparing the database, please wait a moment...")
      dir.create(jabr_cache_dir)
    }

    if (update) {
      message("Updating the database, please wait a moment...")
    }

    jabr_data <-
      package_list_current(
        as = "table",
        limit = 9999,
        url = "http://data.jabarprov.go.id"
      ) %>%
      select(.data$resources, .data$author) %>%
      unnest(.data$resources) %>%
      transmute(
        id = str_extract(.data$id, "^[:alnum:]{8}"),
        title = str_replace_all(.data$name, "\\-", " ") %>%
          str_remove_all("\\.csv$") %>%
          toTitleCase(),
        provider = .data$author %>%
          tolower() %>%
          toTitleCase(),
        provider = na_if(.data$provider, ""),
        last_modified = as.Date(.data$last_modified),
        url
      )

    save(jabr_data, file = file.path(jabr_cache_dir, "jabr_data.rda"))
  }

  load(file = file.path(jabr_cache_dir, "jabr_data.rda"))

  return(jabr_data)
}
