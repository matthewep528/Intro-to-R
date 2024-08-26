#faceted histograms by grouping variable with density curves
#usage: hist.dodge(data, data$x, data$group, bins (optional), "title" (optional) )
#must specify data$arg since non standard evaluations don't work for me most of the time
freqpoly.dodge <- function(data, sample, group, title = "Insert Title") {

  require(ggplot2)
  require(ggh4x)

  #colors <- pull(data, {{ group }})

  ggplot(data, aes(x = {{ sample }}, color = {{ group }})) +
    geom_freqpoly(aes(
      y = after_stat(density)),
      alpha = 0.8)+
    labs(
      title = title,
      x = "Group",
      y = "Frequency",
      color = "Group"
    ) +
    facet_wrap(as.formula(paste0("~", as.name(deparse(substitute(group))))))
}