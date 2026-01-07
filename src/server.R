server <- function(input, output, session) {
  # Route file is a static, straight-line interpolation between
  # start/end coordinates. Replace with a routed polyline if needed.
  route <- read_route_data(
    here::here(
      "data",
      "route",
      "kings_ransom_to_gothenburg.csv"
    )
  )

  runs_data <- shiny::reactive({
    file_path <- here::here(
      "data",
      "turc_2026.xlsx"
    )

    if (!file.exists(file_path)) {
      shiny::validate(
        shiny::need(
          FALSE,
          "Missing data/turc_2026.xlsx."
        )
      )
    }

    read_run_data(file_path)
  })

  output$summary_text <- shiny::renderText({
    runs <- runs_data()

    total_km <- max(runs$cumulative_km, na.rm = TRUE)

    paste0(
      "Runs logged: ",
      nrow(runs),
      " | Total club distance: ",
      round(total_km, 1),
      " km"
    )
  })

  output$route_map <- leaflet::renderLeaflet({
    runs <- runs_data()
    markers <- build_run_markers(runs, route)

    leaflet::leaflet(route) |>
      leaflet::addProviderTiles("CartoDB.Positron") |>
      leaflet::addPolylines(
        lng = ~lon,
        lat = ~lat,
        color = "#2c7fb8",
        weight = 3,
        opacity = 0.8
      ) |>
      leaflet::addCircleMarkers(
        data = markers,
        lng = ~lon,
        lat = ~lat,
        radius = 5,
        color = "#d95f0e",
        fillOpacity = 0.9,
        label = ~paste0(
          "Run ",
          run_index,
          " - ",
          round(cumulative_km, 1),
          " km"
        )
      )
  })
}
