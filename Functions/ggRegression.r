# ggplotRegression
# use to plot linear model with summary statistics and error
# Usage: ggplotRegression(data)
ggRegression <- function(fit, title = "title") {
  require(ggplot2)

  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) +
    geom_point() +
    stat_smooth(
      method = "lm",
      geom = "smooth"
    ) +
    labs(
      title = title,
      subtitle = paste(
        "Adj R2 = ", signif(summary(fit)$adj.r.squared, 5),
        "Intercept =", signif(fit$coef[[1]], 5),
        " Slope =", signif(fit$coef[[2]], 5),
        " P =", signif(summary(fit)$coef[2, 4], 5)
      )
    )
}
