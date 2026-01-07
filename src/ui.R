ui <- shiny::fluidPage(
  shiny::tags$head(
    shiny::includeCSS(
      here::here("www", "dark_mode.css")
    )
  ),
  shiny::titlePanel(
    "TU Run Club 2026 - Sale to Gothenburg"
  ),
  shiny::tags$hr(),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::h2("Tracking TURC in 2026"),
      shiny::br(),
      shiny::p(
        paste0(
          "This app has been created to map TURCs 2026 running ",
          "escapades and to see if we collectively make it all ",
          "the way from the King's Ransom in Sale to Gothenburg ",
          "Opera House."
        )
      ),
      shiny::br(),
      shiny::p(
        "Explore our progress on the map or switch to the ",
        shiny::strong("Runners"),
        " tab to see individuals contributions."
      )
    ),
    shiny::mainPanel(
      shiny::tabsetPanel(
        shiny::tabPanel(
          "Map",
          leaflet::leafletOutput("route_map", height = 600),
          shiny::verbatimTextOutput("summary_text"),
          shiny::verbatimTextOutput("remaining_text")
        ),
        shiny::tabPanel(
          "Runners",
          plotly::plotlyOutput("runner_plot", height = 500)
        )
      )
    )
  )
)
