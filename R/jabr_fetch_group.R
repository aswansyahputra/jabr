#' Fetch group of datasets
#'
#' Download and parse the dataset available at Open Data Jawa Barat into R. This function will download multiple datasets which have same \code{group_id}.
#'
#' @param group_id The group id of dataset. It only accepts single group id.
#' @param keep_title Whether to keep the dataset title in result. If the result is a table, the title is saved in "title" column. If the result is a list, the title is saved as list name.
#' @param as If \code{as = "table"}, the fetched datasets will be saved in "dataset" column with list-column type where you can run \code{tidyr::unnest()} afterwards. Otherwise the fetched datasets will be saved as list.
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
#' # for example, we want to fetch data about gini ratio in west java since 2011 to 2017.
#' # The group_id of this data is "78358b54".
#' jabr_fetch_group("78358b54") %>%
#'   tidyr::unnest(cols = c(dataset))
#' }
#'
#' @export
jabr_fetch_group <- function(group_id, keep_title = TRUE, as = "table") {
  as <- arg_match(as, values = c("table", "list"))

  if (length(group_id) > 1) {
    stop("Please supply one `group_id` only", call. = FALSE)
  }

  if (!is.character(group_id) || nchar(group_id) != 8L) {
    stop("`group_id` must be 8 digits character", call. = FALSE)
  }

  jabr_cache_dir <- user_cache_dir("jabr")

  load(file = file.path(jabr_cache_dir, "jabr_data.rda"))

  id_ok <- keep(group_id, ~ is.element(.x, jabr_data$group_id))
  id_not_ok <- keep(group_id, ~ !is.element(.x, jabr_data$group_id))

  if (length(id_not_ok) == length(group_id)) {
    stop("Can't locate the supplied `group_id`, please re-check it.", call. = FALSE)
  }

  res <-
    jabr_data %>%
    dplyr::filter(.data$group_id %in% id_ok) %>%
    mutate(dataset = map(url, ckan_fetch)) %>%
    select(
      -.data$id,
      -.data$group_id,
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
