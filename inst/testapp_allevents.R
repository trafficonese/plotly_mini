library(shiny)
library(plotly)
# devtools::install_github("ropensci/plotly")


ui <- fluidPage(
  plotlyOutput("plot"),
  verbatimTextOutput("hover"),
  verbatimTextOutput("click"),
  verbatimTextOutput("selected"),
  verbatimTextOutput("selecting"),
  verbatimTextOutput("brushed"),
  verbatimTextOutput("brushing")
)

server <- function(input, output, session) {
  
  nms <- row.names(mtcars)
  
  output$plot <- renderPlotly({
    p <- plot_ly(mtcars, x = ~mpg, y = ~wt, type = 'bar', customdata = nms, source = "B")
    p %>% layout(dragmode = "select") %>%
      highlight(on = "plotly_click", off = "plotly_doubleclick",
                opacityDim = 0.3, selected = attrs_selected(opacity = 0.7))# %>%
      # event_register("plotly_selecting")
  })
  
  output$hover <- renderPrint({
    d <- event_data("plotly_hover", source = "B")
    if (is.null(d)) "Hover events appear here (unhover to clear)" else d
  })
  
  output$click <- renderPrint({
    d <- event_data("plotly_click", source = "B")
    if (is.null(d)) "Click events appear here (double-click to clear)" else d
  })
  
  output$selected <- renderPrint({
    d <- event_data("plotly_selected", source = "B")
    if (is.null(d)) "Click and drag events (i.e., select/lasso) appear here (double-click to clear)" else d
  })
  
  output$selecting <- renderPrint({
    d <- event_data("plotly_selecting", source = "B")
    if (is.null(d)) "Click and drag events (i.e., select/lasso) appear here (double-click to clear)" else d
  })
  
  output$brush <- renderPrint({
    d <- event_data("plotly_brushed", source = "B")
    if (is.null(d)) "Extents of the selection brush will appear here." else d
  })
  
  output$brushing <- renderPrint({
    d <- event_data("plotly_brushing", source = "B")
    if (is.null(d)) "Extents of the selection brush will appear here." else d
  })
  
}

shinyApp(ui, server)
