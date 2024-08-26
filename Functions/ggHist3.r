ggHist3 <- function(data, x, bins = 20, title = "Insert Title", x_lab = "x", group = NULL) {
    require(ggplot2)
    require(ggh4x)
    require(dplyr)
    require(rlang)

    x_sym <- rlang::sym(x)
    group_sym <- if (!is.null(group)) rlang::sym(group) else NULL

    # Calculate mean and sd, handling optional grouping
    if (is.null(group)) {
        stats <- data %>%
            summarise(Mean = mean(!!x_sym, na.rm = TRUE), SD = sd(!!x_sym, na.rm = TRUE)) %>%
            mutate(Label = sprintf("Mean = %.2f, SD = %.2f", Mean, SD))

        subtitle_text <- stats$Label
    } else {
        stats <- data %>%
            group_by(!!group_sym) %>%
            summarise(Mean = mean(!!x_sym, na.rm = TRUE), SD = sd(!!x_sym, na.rm = TRUE)) %>%
            mutate(Label = sprintf("%s: Mean = %.2f, SD = %.2f", as.character(!!group_sym), Mean, SD)) %>%
            ungroup()

        subtitle_text <- paste(stats$Label, collapse = "; ")
    }

    gg <- ggplot(data, aes(x = !!x_sym)) +
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
        gg <- gg + aes_string(fill = group) + # Using aes_string for backward compatibility
            facet_wrap(vars(!!group_sym))
    }

    return(gg)
}
