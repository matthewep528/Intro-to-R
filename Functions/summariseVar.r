# Function to summarize variables with optional grouping
# Usage: summarize.var(dataset, var, group_var (optional))
summarize.var <- function(dataset, variable, group_var = NULL) {
  require(tidyverse)
  require(rlang)

  result <- dataset %>%
    {
      if (!is.null(group_var)) dplyr::group_by({{ group_var }}) else .
    } %>%
    summarise(
      mean = mean({{ variable }}, na.rm = TRUE),
      median = median({{ variable }}, na.rm = TRUE),
      min = min({{ variable }}, na.rm = TRUE),
      max = max({{ variable }}, na.rm = TRUE),
      q25 = quantile({{ variable }}, 0.25, na.rm = TRUE), # first quartile
      q75 = quantile({{ variable }}, 0.75, na.rm = TRUE), # third quartile
      sd = sd({{ variable }}, na.rm = TRUE),
      variance = var({{ variable }}, na.rm = TRUE),
      n = length(na.omit({{ variable }}))
    ) %>%
    mutate(IQR = q75 - q25)

  return(result)
}
