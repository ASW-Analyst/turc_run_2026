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

  output$remaining_text <- shiny::renderText({
    runs <- runs_data()

    total_km <- max(route$distance_km, na.rm = TRUE)
    covered_km <- if (nrow(runs) == 0) 0 else {
      max(runs$cumulative_km, na.rm = TRUE)
    }
    remaining_km <- max(total_km - covered_km, 0)

    paste0(
      "Remaining distance: ",
      round(remaining_km, 1),
      " km"
    )
  })

  output$runner_plot <- plotly::renderPlotly({
    runs <- runs_data()
    totals <- build_runner_totals(runs)

    if (nrow(totals) == 0) {
      return(NULL)
    }

    plotly::plot_ly(
      data = totals,
      x = ~cumulative_km,
      y = ~runner,
      type = "bar",
      orientation = "h",
      marker = list(color = "#2ca25f"),
      hovertemplate = "%{y}<br>%{x:.1f} km<extra></extra>"
    ) |>
      plotly::layout(
        title = "TURC Contributions",
        paper_bgcolor = "#0f1216",
        plot_bgcolor = "#0f1216",
        font = list(color = "#e6e9ee"),
        xaxis = list(
          title = "Cumulative distance (km)",
          color = "#e6e9ee",
          gridcolor = "#2a313a",
          zerolinecolor = "#2a313a"
        ),
        yaxis = list(
          title = "",
          color = "#e6e9ee",
          categoryorder = "array",
          categoryarray = totals$runner
        ),
        margin = list(l = 120, r = 20, t = 50, b = 50)
      )
  })

  output$route_map <- leaflet::renderLeaflet({
    runs <- runs_data()
    markers <- build_run_markers(runs, route)
    covered_km <- if (nrow(runs) == 0) 0 else {
      max(runs$cumulative_km, na.rm = TRUE)
    }
    segments <- build_route_segments(route, covered_km)

    leaflet::leaflet(route) |>
      leaflet::addProviderTiles("CartoDB.Positron") |>
      leaflet::addPolylines(
        data = segments$remaining,
        lng = ~lon,
        lat = ~lat,
        color = "#a6bddb",
        weight = 3,
        opacity = 0.7
      ) |>
      leaflet::addPolylines(
        data = segments$covered,
        lng = ~lon,
        lat = ~lat,
        color = "#2ca25f",
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
