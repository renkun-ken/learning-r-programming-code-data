library(shiny)

ui <- bootstrapPage(
  numericInput("n", label = "Sample size", value = 10, min = 10, max = 100),
  textOutput("mean")
)

server <- function(input, output) {
  output$mean <- renderText(mean(rnorm(input$n)))
}

app <- shinyApp(ui, server)
runApp(app)
