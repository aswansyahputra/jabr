#' Fetch dataset
#'
#' Download and parse the dataset available at Open Data Jawa Barat into R.
#'
#' @param x The dataset list (output from \code{jabr_list_dataset()}). It support single row (single data) and multiple rows (multiple data).
#' @param keep_title Whether to keep the dataset title in result. If the result is a table, the title is saved in "title" column. If the result is a list, the title is saved as list name.
#' @param as Applicable if \code{x} has multiple rows. In \code{as = "table"} the fetched datasets will be saved in "dataset" column with list-column type where you can run \code{unnest()} afterwards. Otherwise the fetched datasets will be saved as list.
#'
#' @importFrom rlang arg_match .data
#' @importFrom dplyr mutate select
#' @importFrom ckanr ckan_fetch
#' @importFrom tidyr unnest
#' @importFrom tibble deframe as_tibble
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
    mutate(dataset = lapply(url, ckan_fetch)) %>%
    select(-.data$provider, -.data$last_updated, -url)

  if (!keep_title) {
    res <- select(res, -.data$title)
  }

  if (NROW(res) == 1) {
    res <- unnest(res, c("dataset"))
  } else if (NROW(res) >= 1) {
    res
    if (as == "list") {
      res <-
        res %>%
        deframe() %>%
        lapply(as_tibble)
    }
  }

  return(res)
}
