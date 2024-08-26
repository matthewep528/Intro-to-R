#faceted histograms by grouping variable with density curves
#usage: hist.sumgroup(data, data$x, data$group, "title", "y_title")
hist.sumgroup <- function(data, x, group, title = "Insert Title") {

  require(ggplot2)
  require(ggh4x)
  require(ggpmisc)
  require(patchwork)

  #create table of summary stats
  summary_stats <- data %>%
  group_by({{group}}) %>%
  summarize(
    mean_val = mean({{x}}, na.rm = TRUE),
    median_val = median({{x}}, na.rm = TRUE),
    iqr_val = IQR({{x}}, na.rm = TRUE)
  )
  summary_stats <- as.data.frame(summary_stats)
  
  #create main graph
  p <- ggplot(data, aes(x = x, fill = group)) +
    geom_histogram(aes(
      y = after_stat(density)),
      bins = 45,
      alpha = 0.8,
      color = "#353535") +
    stat_theodensity(
      col = "#ecd467",
      size = 0.9,
      linetype = "dashed"
    ) +
    labs(
      title = title,
      x = "Group",
      y = "Frequency"
    ) +
    facet_wrap(group)

  #Create empty plot with table
  ggp_table <- ggplot() +
    theme_void() +
    annotate(geom = "table",
            x = 1,
            y = 1,
            label = list(summary_stats))

p + ggp_table

}