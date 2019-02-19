library(shiny)

ui <- fluidPage(
  titlePanel("Random walk"),
  sidebarLayout(
    sidebarPanel(
      numericInput("seed", "Random seed", 123),
      sliderInput("paths", "Paths", 1, 100, 1),
      sliderInput("start", "Starting value", 1, 10, 1, 1),
      sliderInput("r", "Expected return", -0.1, 0.1, 0, 0.001),
      sliderInput("sigma", "Sigma", 0.001, 1, 0.01, 0.001),
      sliderInput("periods", "Periods", 10, 1000, 200, 10)),
  mainPanel(
    plotOutput("plot", width = "100%", height = "600px")
  ))
)

server <- function(input, output) {
  output$plot <- renderPlot({
    set.seed(input$seed)
    mat <- sapply(seq_len(input$paths), function(i) {
      sde::GBM(input$start, input$r, input$sigma, 1, input$periods)
    })
    matplot(mat, type = "l", lty = 1,
      main = "Geometric Brownian motions")
  })
}

app <- shinyApp(ui, server)
runApp(app)
