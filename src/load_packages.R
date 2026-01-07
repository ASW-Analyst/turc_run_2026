required_packages <- c(
  "dplyr",
  "here",
  "leaflet",
  "purrr",
  "readr",
  "readxl",
  "shiny",
  "tibble",
  "tidyr"
)

missing_packages <- required_packages[!vapply(
  required_packages,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]

if (length(missing_packages) > 0) {
  stop(
    "Missing packages: ",
    paste(missing_packages, collapse = ", "),
    ". Install them, then re-run.",
    call. = FALSE
  )
}

invisible(lapply(
  required_packages,
  library,
  character.only = TRUE
))
