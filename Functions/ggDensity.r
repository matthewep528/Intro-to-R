#density plots with optional grouping variable
#can be faceted or together by specifying either group or color
#usage: density.dodge(data, sample, group = "group" (optional), color = "NULL" (optional), title = "title" (optional) )
ggDensity <- function(data, sample, group = NULL, color = NULL, title = "Insert Title") {

  require(ggplot2)

  plot <- ggplot(data, aes(x = {{ sample }})) +
    geom_density() +
    labs(
      title = title,
      y = "Frequency",
      color = NULL
    )

  if (!is.null(group)) {

    colors <- pull(data, {{ group }})

    plot <- plot + aes(color = factor(colors)) +
      facet_wrap(as.formula(paste("~", group))) +
      labs(color = "Group")
  }

  if (!is.null(color)) {

    colors <- pull(data, {{ color }})

    plot <- plot + aes(fill = factor(colors), color = factor(colors), alpha = 0.02) +
      labs(fill = "Group") +
      geom_density(size = 1) +
      guides(color = "none", alpha = "none")
  }

  return(plot)
}