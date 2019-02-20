library(shiny)
library(ggplot2)
library(plotly)

dfN <- data.frame(
  time_stamp = seq.Date(as.Date("2018-04-01"), as.Date("2018-07-30"), 1),
  val = runif(121, 100,1000),
  col = "green", stringsAsFactors = F
)


ui <- fluidPage(
  plotlyOutput("plot"),
  h4("click events"),
  verbatimTextOutput("clicked"),
  h4("SHIFT-click events"),
  verbatimTextOutput("shift_clicked"),
  h4("ALT-click events"),
  verbatimTextOutput("alt_clicked"),
  h4("selection events"),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  output$plot <- renderPlotly({
    key <- highlight_key(dfN)
    p <- ggplot() +
      geom_col(data = key, aes(x = plotly:::to_milliseconds(time_stamp), y = val, fill=I(col))) +
      theme(legend.position="none")
    
    ggplotly(p, source = "Src") %>% layout(xaxis = list(tickval = NULL, ticktext = NULL, type = "date")) %>% 
      highlight(selectize=F, off = "plotly_doubleclick", on = "plotly_click", color = "blue",
                opacityDim = 0.5, selected = attrs_selected(opacity = 1))
  })
  
  
  output$clicked <- renderPrint({
    s <- event_data("plotly_click", source = "Src")
    s
  })
  output$shift_clicked <- renderPrint({
    s <- event_data("plotly_click_persist_on_shift", source = "Src")
    s
  })
  output$alt_clicked <- renderPrint({
    s <- event_data("plotly_alt_click", source = "Src")
    s
  })
  output$selection <- renderPrint({
    s <- event_data("plotly_selected", source = "Src")
    s
  })
}

shinyApp(ui, server)
