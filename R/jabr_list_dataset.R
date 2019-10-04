#' List Dataset
#'
#' List the dataset available at Open Data Jawa Barat.
#'
#' @param update (logical) Whether to update the dataset list.
#'
#' @importFrom rlang .data
#' @importFrom rappdirs user_cache_dir
#' @importFrom ckanr package_list_current
#' @importFrom dplyr select transmute
#' @importFrom tidyr unnest
#'
#' @return A tibble.
#'
#' @export
jabr_list_dataset <- function(update = FALSE) {
  jabr_cache_dir <- user_cache_dir("jabr")

  if (!file.exists(file.path(jabr_cache_dir, "jabr_data.rda")) |
    update) {
    if (!dir.exists(jabr_cache_dir)) {
      message("Preparing the database, please wait...")
      dir.create(jabr_cache_dir)
    }

    if (update) {
      message("Updating the database, please wait...")
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
        title = .data$name,
        provider = .data$author,
        last_updated = as.Date(.data$cache_last_updated),
        url
      )

    save(jabr_data, file = file.path(jabr_cache_dir, "jabr_data.rda"))
  }

  load(file = file.path(jabr_cache_dir, "jabr_data.rda"))

  return(jabr_data)
}
