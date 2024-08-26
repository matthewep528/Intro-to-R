hist.dodge.plotly <- function(data, x, group, title = "Insert Title") {
  require(ggplot2)
  require(ggh4x)

  gg <- ggplot(data, aes(x = x, fill = group)) +
    geom_histogram(aes(y = after_stat(density)),
                   bins = 45,
                   alpha = 0.8,
                   color = "#353535") +
    stat_theodensity(col = "#ecd467",
                     size = 0.9,
                     linetype = "dashed") +
    labs(title = title, x = "Group", y = "Frequency") +
    facet_wrap(group) +
    theme(
      plot.background = element_rect(fill = "#1e1e1e"),
      panel.background = element_rect(fill = "#1e1e1e"),
      axis.text = element_text(color = "#ffffff"),
      axis.title = element_text(color = "#ffffff"),
      strip.text = element_text(color = "#ffffff"),
      strip.background = element_rect(fill = "#1e1e1e")
    )

  ggplotly(gg, tooltip = "text") %>%
    layout(
      font = list(color = "#ffffff"),  # Set text color to white
      paper_bgcolor = "#1e1e1e",      # Set background color
      plot_bgcolor = "#1e1e1e"        # Set plot area background color
    )
}