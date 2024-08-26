# plotlyRegression: Scatterplot with line, SE, and summary statistics
# requires a model to have been created beforehand
# Usage: plotlyRegression(fit, title = "title" (optional))
plotlyRegression <- function(fit, title = "title") {
  require(plotly)

  # Extract model data
  df <- fit$model
  x_var <- names(df)[2]
  y_var <- names(df)[1]

  # Create a scatter plot
  p <- plot_ly(df, x = ~ df[[x_var]], y = ~ df[[y_var]], type = "scatter", mode = "markers")

  # Get confidence interval data
  confint_df <- data.frame(predict(fit, interval = "confidence"))
  confint_df[[x_var]] <- df[[x_var]] # Adding the x variable to the dataframe

  # Add linear regression line and 95% confidence interval
  p <- p %>%
    add_lines(
      x = confint_df[[x_var]],
      y = confint_df$fit,
      line = list(color = "blue")
    ) %>%
    add_ribbons(
      x = confint_df[[x_var]],
      ymin = confint_df$lwr,
      ymax = confint_df$upr,
      line = list(color = "transparent"),
      fillcolor = "rgba(0, 100, 255, 0.2)"
    )

  # Create subtitle with summary statistics
  subtitle <- paste(
    "Adj R2 =", signif(summary(fit)$adj.r.squared, 5),
    ", Intercept =", signif(fit$coef[[1]], 5),
    ", Slope =", signif(fit$coef[[2]], 5),
    ", P =", signif(summary(fit)$coef[2, 4], 5)
  )

  # Add layout with combined title and subtitle
  p <- p %>%
    layout(
      title = list(
        text = paste0(title, "<br><sup>", subtitle, "</sup>"),
        font = list(size = 16)
      ),
      plot_bgcolor = "#2c2c2c",
      paper_bgcolor = "#2c2c2c",
      font = list(color = "#ffffff"),
      xaxis = list(title = x_var, color = "#ffffff"),
      yaxis = list(title = y_var, color = "#ffffff")
    )

  return(p)
}
