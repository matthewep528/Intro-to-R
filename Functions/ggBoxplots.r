# Faceted boxplot function with one box per group
# Usage: ggBoxplots(data, x, fill, title)
ggBoxplots <- function(data, x, fill, title = "title") {
  require(tidyverse)
  
  ggplot(data, aes(x = {{ x }}, y = "", fill = {{ fill }})) +
    geom_boxplot() +
    labs(title = title) +
    facet_wrap(as.formula(paste0("~", as.name(deparse(substitute(fill))))), scales = "free")
}
# Example usage:
# ggBoxplots(your_data_frame, x_column_name, fill_column_name, "Your Title")