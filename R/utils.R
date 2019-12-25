as_id <- function(x) {
  structure(x, class = "id")
}

c.id <- function(x, ...) {
  as_id(NextMethod())
}

`[.id` <- function(x, i) {
  as_id(NextMethod())
}

print.id <- function(x, ...) {
  cat(x, sep = " ")
  invisible(x)
}

#' @importFrom pillar type_sum
type_sum.id <- function(x) {
  "id"
}

#' @importFrom pillar new_pillar_shaft_simple
pillar_shaft.id <- function(x, ...) {
  x[is.na(x)] <- NA
  new_pillar_shaft_simple(x, align = "right", min_width = 8)
}
