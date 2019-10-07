#' Fetch dataset
#'
#' Download and parse the dataset available at Open Data Jawa Barat into R.
#'
#' @param x The dataset list (output from \code{jabr_list_dataset()}). It support single row (single data) and multiple rows (multiple data).
#' @param keep_title Whether to keep the dataset title in result. If the result is a table, the title is saved in "title" column. If the result is a list, the title is saved as list name.
#' @param as Applicable if \code{x} has multiple rows. In \code{as = "table"} the fetched datasets will be saved in "dataset" column with list-column type where you can run \code{unnest()} afterwards. Otherwise the fetched datasets will be saved as list.
#'
#' @importFrom rlang arg_match .data
#' @importFrom dplyr mutate mutate_if select
#' @importFrom ckanr ckan_fetch
#' @importFrom tidyr unnest
#' @importFrom tibble deframe as_tibble
#' @importFrom purrr map
#'
#' @return A tibble or list of tibble.
#'
#' @export
jabr_fetch <- function(x, keep_title = TRUE, as = "table") {
  if (!is.data.frame(x)) {
    stop("`x` must be a dataframe", call. = FALSE)
  }

  if (NCOL(x) != 4) {
    stop("Column names do not match.", call. = FALSE)
  }

  if (!all(colnames(x) %in% c("title", "provider", "last_updated", "url"))) {
    stop("Column names do not match.", call. = FALSE)
  }

  as <- arg_match(as, values = c("table", "list"))

  res <-
    x %>%
    mutate(dataset = map(url, ckan_fetch)) %>%
    select(-.data$provider, -.data$last_updated, -url)

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
