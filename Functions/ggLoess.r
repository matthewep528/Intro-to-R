# LOESS curve using ggplot with optional fill and color parameters
# usage: ggLoess(data, x, y, fill = fill (optional), color = color (optional), title = "title" (optional))
ggLoess <- function(data, x, y, fill = NULL, color = NULL, title = "title") {

    require(tidyverse)

    p <- gplot(data, aes(x = {{ x }}, y = {{ y }})) +
        geom_point() +
        geom_smooth(method = "loess") +
        labs(
            x = "Predictor",
            y = "Outcome",
            title = title
        )

    if(!is.null(fill)) {
        p + ggplot(data, aes(fill = {{ sex }}))
    }

    if(!is.null(color)) {
        p + ggplot(data, aes(color = {{ color }}))
    }

    return(p)
}