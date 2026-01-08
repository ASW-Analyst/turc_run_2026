read_run_data <- function(file_path) {
  runs <- readxl::read_excel(file_path)

  required_columns <- c("Date", "Distance")
  missing_columns <- setdiff(required_columns, names(runs))

  if (length(missing_columns) > 0) {
    stop(
      "Missing required columns: ",
      paste(missing_columns, collapse = ", "),
      call. = FALSE
    )
  }

  participant_columns <- setdiff(names(runs), required_columns)

  if (length(participant_columns) == 0) {
    stop("No participant columns found.", call. = FALSE)
  }

  runs |>
    dplyr::mutate(
      Date = as.Date(.data$Date),
      Distance = as.numeric(.data$Distance)
    ) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(participant_columns),
        as.numeric
      )
    ) |>
    dplyr::mutate(
      runner_count = base::rowSums(
        dplyr::pick(
          dplyr::all_of(participant_columns)
        ),
        na.rm = TRUE
      )
    ) |>
    dplyr::mutate(
      run_total_km = .data$runner_count * .data$Distance
    ) |>
    dplyr::mutate(
      cumulative_km = cumsum(.data$run_total_km)
    ) |>
    dplyr::filter(!is.na(.data$cumulative_km))
}

read_route_data <- function(file_path) {
  route <- readr::read_csv(
    file_path,
    show_col_types = FALSE
  )

  expected <- c("lat", "lon", "distance_km")
  missing <- setdiff(expected, names(route))

  if (length(missing) > 0) {
    stop(
      "Route file missing columns: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }

  route |>
    dplyr::arrange(.data$distance_km)
}

interpolate_route_point <- function(route, target_km) {
  max_km <- max(route$distance_km, na.rm = TRUE)
  clipped_km <- min(target_km, max_km)

  lat <- stats::approx(
    x = route$distance_km,
    y = route$lat,
    xout = clipped_km
  )$y

  lon <- stats::approx(
    x = route$distance_km,
    y = route$lon,
    xout = clipped_km
  )$y

  tibble::tibble(
    lat = lat,
    lon = lon,
    distance_km = clipped_km
  )
}

build_run_markers <- function(runs, route) {
  purrr::map_dfr(
    runs$cumulative_km,
    ~ interpolate_route_point(route, .x)
  ) |>
    dplyr::mutate(
      run_index = dplyr::row_number(),
      cumulative_km = runs$cumulative_km
    )
}

build_route_segments <- function(route, covered_km) {
  max_km <- max(route$distance_km, na.rm = TRUE)
  clipped_km <- min(max(covered_km, 0), max_km)

  cut_point <- interpolate_route_point(route, clipped_km)

  covered <- route |>
    dplyr::filter(.data$distance_km <= clipped_km) |>
    dplyr::bind_rows(cut_point) |>
    dplyr::distinct(.data$distance_km, .keep_all = TRUE) |>
    dplyr::arrange(.data$distance_km)

  remaining <- route |>
    dplyr::filter(.data$distance_km >= clipped_km) |>
    dplyr::bind_rows(cut_point) |>
    dplyr::distinct(.data$distance_km, .keep_all = TRUE) |>
    dplyr::arrange(.data$distance_km)

  list(
    covered = covered,
    remaining = remaining
  )
}

build_runner_totals <- function(runs) {
  excluded <- c(
    "Date",
    "Distance",
    "runner_count",
    "run_total_km",
    "cumulative_km"
  )
  participant_columns <- setdiff(names(runs), excluded)

  runs |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(participant_columns),
      names_to = "runner",
      values_to = "ran"
    ) |>
    dplyr::mutate(
      ran = as.numeric(.data$ran),
      distance = .data$Distance
    ) |>
    dplyr::group_by(.data$runner) |>
    dplyr::summarise(
      cumulative_km = sum(.data$ran * .data$distance, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$cumulative_km))
}
