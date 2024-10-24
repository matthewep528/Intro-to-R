###############################################################################
#' EPIDEM 2186 - Introduction to R for Public Health
#' Purpose: Module 4 - Creating variable and value labels
#' Author: Marquis Hawkins
###############################################################################

# Loading the necessary packages
# First, ensuring pacman is installed in loaded
# The pacman package has convenient commands for installing and loading packages
if (!require(pacman)) install.packages("pacman")

pacman::p_load(
  here, # file locator
  labelled, # used to create haven labels
  magrittr # using %>% operator for piping commands
)

#' Loading the R dataset by running the data import script saved in the
#' indicate sub-folders
#' Note, the source function only works with R scripts NOT markdown files
source(here::here(
  "modules", "02_data_management", "module_3_acquisition", "code",
  "data_import_practice.R"
))

# It is import to label all levels of categorical variables for clarity
# Labels will also appear in tables and figures

# Checking if value labels exist
# No values exist so I will create them
val_labels(some_data)

# Assigning value labels for each variable separately
val_labels(some_data) <- list(
  gender = c(
    "Men" = 1,
    "Women" = 2
  ),
  married = c(
    "Married" = 1,
    "Widowed" = 2,
    "Divorced" = 3,
    "Separated" = 4,
    "Never married" = 5,
    "Living w/partner" = 6,
    "Refused" = 77,
    "Don't know" = 99
  )
)

# Applying the same value labels to multiple variables
# list all of the columns to labels
val_labels(some_data[, c(
  "dpq010", "dpq020", "dpq030", "dpq040",
  "dpq050", "dpq060", "dpq070", "dpq080",
  "dpq090"
)]) <-
  # assign labels to each value
  c(
    "Not at all" = 0,
    "Several days" = 1,
    "More than half" = 2,
    "Nearly every day" = 3,
    "Refused" = 7,
    "Don't know" = 9
  )

val_labels(some_data[, c("paq665", "paq650")]) <-
  c(
    "Yes" = 1,
    "No" = 2
  )

#' Converting numeric to nominal factors using labels
#' We didn't discuss this in class, but once you make labels, you will need
#' to convert the class type to factor
#' This step is important for creating properly labels graphs and tables
#' You can convert each variable manually, using the as.factor function
#' Alternatively, you can use the across() which applies a function to multiple
#' variables at the same time
#' As a good programming practice, it is better not to repeat code when possible
#' less prone to error, easier to debug when error messages appear

some_data <- some_data %>%
  mutate(across(
    .cols = c(
      gender, married, dpq010:dpq090 # indicates the columns
    ), 
    .fns = haven::as_factor # indicates the function to apply
  )) 

# note here, I am apply the as_factor function from the haven package
# Also note that I do NOT include the () after as_factor.
# only list the categorical variables in this step

# checking the structure to make sure the object types are as intended
# this will also return the variable label
# str(some_data)

###############################################################################
# Labeling values using base R
###############################################################################

# Labeling a nominal variable
some_data$paq665 <- factor(some_data$paq665,
  levels = c(1, 2),
  labels = c("Yes", "No")
)

# str(some_data$paq665)

# Labeling an ordered variable


###############################################################################
# Applying new variable labels
# Most of these already have labels, but I will create new labels for practice
# You may also create new labels to better confirm to labelling conventions
###############################################################################

# Checking variable names, making sure they are as expected
# checking if labels exist
# var_label(some_data)

var_label(some_data) <- list(
  seqn = "Study ID",
  bmi = "Body Mass Index",
  age = "Age, yrs",
  gender = "Gender",
  race = "Race/ethnicity",
  married = "Marital Status",
  income = "Povery-income ratio",
  sld_wd = "Weekday sleep duration",
  sld_we = "Weekend sleep duration",
  paq650 = "Lesiure Vigorous PA",
  paq655 = "Leisure Vigorous PA Frequency",
  pad660 = "Lesisure Vigorous PA Minutes",
  paq665 = "Lesiure Moderate PA",
  paq670 = "Leisure Moderate PA Frequency",
  pad675 = "Lesisure Moderate PA Minutes",
  pad680 = "Sedentary minutes",
  dpq010 = "Little interest doing things",
  dpq020 = "Feeling down, depressed",
  dpq030 = "Trouble sleeping",
  dpq040 = "Low energy",
  dpq050 = "Low or high appetite",
  dpq060 = "Feeling bad about self",
  dpq070 = "Trouble concentrating",
  dpq080 = "Moving/speaking slow/fast",
  dpq090 = "Suicidal thoughts",
  dpq100 = "Experiencing difficulty"
)
