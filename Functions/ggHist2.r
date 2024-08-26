ggHist2 <- function(data, x, bins = 20, title = "Insert Title", x_lab = "x", group = NULL) {
    require(ggplot2)
    require(ggh4x)
    require(dplyr)

    # Calculate mean and sd, handling optional grouping
    if (is.null(group)) {
        stats <- data %>%
            summarise(Mean = mean({{ x }}, na.rm = TRUE), SD = sd({{ x }}, na.rm = TRUE)) %>%
            mutate(Label = sprintf("Mean = %.2f, SD = %.2f", Mean, SD))

        subtitle_text <- stats$Label
    } else {
        stats <- data %>%
            group_by({{ group }}) %>%
            summarise(Mean = mean({{ x }}, na.rm = TRUE), SD = sd({{ x }}, na.rm = TRUE)) %>%
            mutate(Label = sprintf("%s: Mean = %.2f, SD = %.2f", {{ group }}, Mean, SD)) %>%
            ungroup()

        subtitle_text <- paste(stats$Label, collapse = "; ")
    }

    gg <- ggplot(data, aes(x = {{ x }})) +
        geom_histogram(
            aes(y = after_stat(density)),
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
            subtitle = subtitle_text,
            x = x_lab,
            y = "Frequency"
        )

    if (!is.null(group)) {
        gg <- gg + aes(fill = {{ group }}) +
            facet_wrap(vars({{ group }}))
    }

    return(gg)
}
