#simple violin plot function
#usage: ggViolin(data, y, fill, "title" (optional))
ggViolin <- function(data, y, fill, title = "title") {
    require(tidyverse)

    ggplot(data, aes(x = {{ fill }}, y = {{ y }}, fill = {{ fill }})) +
        geom_violin() +
        labs(title = title)
}