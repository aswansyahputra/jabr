#' Fetch dataset
#'
#' Download and parse the dataset available at Open Data Jawa Barat into R.
#'
#' @param id The character id of dataset. It accepts single id or multiple ids. Non-matched id(s) will be ignored.
#' @param keep_title Whether to keep the dataset title in result. If the result is a table, the title is saved in "title" column. If the result is a list, the title is saved as list name.
#' @param as Applicable if \code{x} has multiple rows. In \code{as = "table"} the fetched datasets will be saved in "dataset" column with list-column type where you can run \code{unnest()} afterwards. Otherwise the fetched datasets will be saved as list.
#'
#' @importFrom rlang arg_match .data
#' @importFrom rappdirs user_cache_dir
#' @importFrom dplyr mutate mutate_if select
#' @importFrom ckanr ckan_fetch
#' @importFrom tidyr unnest
#' @importFrom tibble deframe as_tibble
#' @importFrom purrr map keep
#'
#' @return A tibble or list of tibble.
#'
#' @examples
#' \donttest{
#' library(jabr)
#'
#' (x <- jabr_list_dataset())
#'
#'
#' # for example, we want to fetch data about number of application available in west java.
#' # The id of this data is "3a51a670".
#' jabr_fetch("3a51a670")
#' }
#'
#' @export
jabr_fetch <- function(id, keep_title = TRUE, as = "table") {
  if (!is.character(id) || nchar(id) != 8L) {
    stop("`id` must be 8 digits character", call. = FALSE)
  }

  as <- arg_match(as, values = c("table", "list"))

  jabr_cache_dir <- user_cache_dir("jabr")
  load(file = file.path(jabr_cache_dir, "jabr_data.rda"))

  id_ok <- keep(id, ~ is.element(.x, jabr_data$id))
  id_not_ok <- keep(id, ~ !is.element(.x, jabr_data$id))

  if (length(id_not_ok) == length(id)) {
    stop("Can't locate the supplied id(s), please re-check it.", call. = FALSE)
  }

  if (length(id_not_ok) > 1L) {
    warning(paste("Can't locate these id(s):", paste0(id_not_ok, collapse = ", "), ". They will be ignored."))
  }

  if (length(id_not_ok) == 1L) {
    warning(paste0("Can't locate ", id_not_ok, ". It will be ignored."))
  }

  res <-
    jabr_data %>%
    dplyr::filter(.data$id %in% id_ok) %>%
    mutate(dataset = map(url, ckan_fetch)) %>%
    select(
      -.data$id,
      -.data$provider,
      -.data$last_modified,
      -.data$url
    )

  if (!keep_title) {
    res <- select(res, -.data$title)
  }

  if (NROW(res) == 1) {
    res <-
      res %>%
      unnest(c(.data$dataset)) %>%
      mutate_if(is.factor, as.character)
  } else if (NROW(res) >= 1) {
    res <-
      res %>%
      mutate(
        dataset = map(.data$dataset, ~ mutate_if(.x, is.factor, as.character))
      )

    if (as == "list") {
      res <-
        res %>%
        deframe() %>%
        map(as_tibble)
    }
  }

  return(res)
}
