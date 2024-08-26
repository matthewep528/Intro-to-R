qqTest <- function(data, sample, title = "title", facet_var = NULL) {
    require(tidyverse)

    gg <- ggplot(data,
        aes(sample = {{ sample }})) +
        stat_qq() +
        stat_qq_line(
            size = 0.8,
        ) +
        labs(
            title = title,
            x = "Theoretical Quantiles",
            y = "Sample Quantiles"
        ) +
        guides(color = "none")

    if (!is.null(facet_var)) {

        # Extract colors from facet_var variable
        colors <- pull(data, {{ facet_var }})

        gg <- gg + aes(color = factor(colors)) + facet_wrap(as.formula(paste("~", facet_var)))
    }

    return(gg)
}
