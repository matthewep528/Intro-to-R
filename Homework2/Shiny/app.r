# app.R

# Load required packages
library(shiny)
library(ggplot2)
library(ggh4x)
library(rlang)
library(here)
library(rsconnect)

# Set the root directory using here::i_am()

# Check if we're running on shinyapps.io
if (nzchar(Sys.getenv("SHINY_PORT"))) {
    # On shinyapps.io
    # Set the root directory to the directory containing app.R
    here::i_am("app.R")
    # Load data from the data directory relative to app.R
    dietAdult <- readRDS(here("data", "dietAdult.rds"))
} else {
    # Running locally
    # Set the root directory to the current working directory ("Intro-to-R")
    here::i_am("Homework2/Shiny/app.R")
    # Load data from the specified path
    dietAdult <- readRDS(here("Homework2", "Shiny", "data", "dietAdult.rds"))
}

# Identify numeric variables for x-axis selection
numeric_vars <- names(dietAdult)[sapply(dietAdult, is.numeric)]

# Identify factor or character variables for grouping
grouping_vars <- c("None", names(dietAdult)[sapply(dietAdult, function(x) is.factor(x) | is.character(x))])

# Define UI
ui <- fluidPage(
    titlePanel("Interactive Histogram with ggHist"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "x_var",
                label = "Select X Variable",
                choices = numeric_vars
            ),
            selectInput(
                inputId = "group_var",
                label = "Select Grouping Variable (optional)",
                choices = grouping_vars
            )
        ),
        mainPanel(
            plotOutput(outputId = "histPlot")
        )
    )
)

# Define server logic
server <- function(input, output) {
    output$histPlot <- renderPlot({
        # Convert input strings to symbols for tidy evaluation
        x_var <- sym(input$x_var)

        # Check if a grouping variable is selected
        if (input$group_var == "None") {
            # Call ggHist without grouping
            ggHist(data = dietAdult, x = !!x_var)
        } else {
            # Convert grouping variable input to symbol
            group_var <- sym(input$group_var)
            # Call ggHist with grouping
            ggHist(data = dietAdult, x = !!x_var, group = !!group_var)
        }
    })
}

# Include ggHist function
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
            facet_wrap(vars({{ group }}))
    }

    return(gg)
}

# Run the application
shinyApp(ui = ui, server = server)
