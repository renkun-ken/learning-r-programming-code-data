library(shiny)
library(shinydashboard)
library(formattable)
library(cranlogs)

ui <- dashboardPage(
  dashboardHeader(title = "CRAN Downloads"),
  dashboardSidebar(sidebarMenu(
    menuItem("Last week", tabName = "last_week", icon = icon("list")),
    menuItem("Last month", tabName = "last_month", icon = icon("list"))
  )),
  dashboardBody(tabItems(
    tabItem(tabName = "last_week", 
      fluidRow(tabBox(title = "Total downloads",
        tabPanel("Total", formattableOutput("last_week_table"))),
        tabBox(title = "Top downloads",
          tabPanel("Top", formattableOutput("last_week_top_table"))))),
    tabItem(tabName = "last_month", 
      fluidRow(tabBox(title = "Total downloads",
        tabPanel("Total", plotOutput("last_month_barplot"))),
        tabBox(title = "Top downloads",
          tabPanel("Top", formattableOutput("last_month_top_table")))))
  ))
)

server <- function(input, output) {
  output$last_week_table <- renderFormattable({
    data <- cran_downloads(when = "last-week")
    formattable(data, list(count = color_bar("lightblue")))
  })
  
  output$last_week_top_table <- renderFormattable({
    data <- cran_top_downloads("last-week")
    formattable(data, list(count = color_bar("lightblue"),
      package = formatter("span", style = "font-family: monospace;")))
  })
  
  output$last_month_barplot <- renderPlot({
    data <- subset(cran_downloads(when = "last-month"), count > 0)
    with(data, barplot(count, names.arg = date),
      main = "Last month downloads")
  })
  
  output$last_month_top_table <- renderFormattable({
    data <- cran_top_downloads("last-month")
    formattable(data, list(count = color_bar("lightblue"),
      package = formatter("span", style = "font-family: monospace;")))
  })
}

runApp(shinyApp(ui, server))
