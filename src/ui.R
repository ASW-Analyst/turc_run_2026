ui <- shiny::fluidPage(
  shiny::titlePanel(
    "TU Run Club 2026 - Sale to Gothenburg"
  ),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::helpText(
        "Using data/turc_2026.xlsx"
      )
    ),
    shiny::mainPanel(
      leaflet::leafletOutput("route_map", height = 600),
      shiny::verbatimTextOutput("summary_text")
    )
  )
)
