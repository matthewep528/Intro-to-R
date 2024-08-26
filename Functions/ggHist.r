# ggplot histogram function with optional faceting variable
# Usage: gg.hist(data, x, bins (optional), title (optional), data$group (optional))
ggHist <- function(data, x, bins = 20, title = "Insert Title", x_lab = "x", group = NULL) {
  require(ggplot2)
  require(ggh4x)

  gg <- ggplot(data, aes(x = {{ x }})) +
    geom_histogram(
      aes(
        y = after_stat(density)
      ),
      bins = bins,
      alpha = 0.8,
      color = "#353535"
    ) +
    stat_theodensity(
      col = "#ecd467",
      size = 0.9,
      linetype = "dashed"
    ) +
    labs(
      title = title,
      x = x_lab,
      y = "Frequency"
    )

  if (!is.null(group)) {
    gg <- gg + aes(fill = {{ group }}) +
      facet_wrap({{ group }})
  }

  return(gg)
}
