#faceted boxplot written in plotly
facBoxPlotly <- function(data, x, y, fill, title) {

  require(ggthemr)
  require(plotly)

  ggthemr("flat dark")

  p <- plot_ly(data, x = x, y = y, color = fill, type = "box") %>%
    layout(
        title = title,
        font = list(color = "#ffffff"), # Set text color to white
        paper_bgcolor = "#1e1e1e",      # Set background color
        plot_bgcolor = "#1e1e1e"        # Set plot area color
    )

  return(p)
}