source("src/load_packages.R")
source("src/utils.R")
source("src/ui.R")
source("src/server.R")

shiny::shinyApp(ui = ui, server = server)
