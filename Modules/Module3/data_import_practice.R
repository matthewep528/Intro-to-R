##############################################################################
#' Project Title: Module 3 - Data acquisition
#' Programmer: Marquis Hawkins
#' Purpose: To provide examples of R functions to Import, Merge, Bind, Pivot,
#' and Subset your data
#'
#' Specifically, you will learn functions to:
# 1. Import foreign (e.g., csv, SAS) data frame into R
# 2. Merge and bind multiple data frames
# 3. Create subsets
# 4. Reshape your data
# 5. Load and save R data frames
##############################################################################

# Setup - loading packages used in the assignment
pacman::p_load(
  rio, # flexible import function
  here, # file locator, uses relative file paths
  dplyr, # select and filter functions (i.e., sub-setting)
  magrittr, # piping
  tidyr # pivot/reshape data frames - used in textbook but not in class
)

###############################################################################
#' 1. Importing "foreign" data frames
#'
#' 1. Import each data frame
#' 2. Look at the dimensions
#' 3. Look at data structure
#' check if data was loaded as expected (e.g., correct number of observations)
###############################################################################

bmx_data <- rio::import(here::here(
  "Modules",
  "Module3",
  "bmx.dta" # name of file and file type (STATA file)
)) %>%
  select(seqn, bmi = bmxbmi) # selecting and renaming variables

###############################################################################
# Also check if data sets were imported correctly
# Once I verify correctness, I "comment" out the function because I no longer
# need them to run
###############################################################################

# prints the dimensions, # of observations, # of columns
# dim(bmx_data)

# prints the dimension, class type and values for first 6 obs for each column
# str(bmx_data)

###############################################################################
# Repeating the process for each data frame
###############################################################################

demo_data <- rio::import(here::here("Modules", "Module3", "demo.xpt")) %>%
  dplyr::select(
    seqn = SEQN,
    gender = RIAGENDR,
    age = RIDAGEYR,
    race = RIDRETH1,
    edu = DMDEDUC2,
    married = DMDMARTL,
    income = INDFMPIR
  )
# dim(demo_data)
# str(demo_data)

paq_data <- rio::import(here::here("Modules", "Module3", "paq_j.sas7bdat")) %>%
  janitor::clean_names()

# dim(paq_data)
# str(paq_data)

sleep_data <- rio::import(here::here("Modules", "Module3", "sleep.csv")) %>%
  select(
    seqn = SEQN,
    sld_wd = SLD012,
    sld_we = SLD013,
    sl_time_wd = SLQ300,
    wake_time_wd = SLQ310,
    sl_time_we = SLQ320,
    wake_time_we = SLQ330,
    sl_midpoint = midpoint_weighted_weekly
  )

dpq_data <- rio::import(here::here("Modules", "Module3", "DPQ_J.XPT")) %>%
  janitor::clean_names()

# dim(sleep_data)
# str(sleep_data)

###############################################################################
#' Merging data frames
#' Make sure you unique identifier, often the study id, is spelled the same
#' in each data frame
#'
#' The dplyr::full_join() merges two data frames
#' for merging multiple, you need to use a sequence of dplyr::full_join()
###############################################################################

all_data <- bmx_data %>%
  dplyr::full_join(demo_data, by = "seqn") %>%
  dplyr::full_join(sleep_data, by = "seqn") %>%
  dplyr::full_join(paq_data, by = "seqn") %>%
  dplyr::full_join(dpq_data, by = "seqn") %>%
  janitor::clean_names()

# Reminder to check the structure to ensure the dataset is as expected
# str(all_data)

###############################################################################
#' Alternative merge strategy
#' The plyr package contains a join_all() that allows you to merge multiple
#' data frames in one step
#' Benefit - Few lines of code, less prone to error
#' Note the plyr is different the dplyr
#' Because plyr has function names similr to dplyr function, this will cause
#' conflicts. If you receive an error message in your code, using the "::"
#' operator that links package to function will fix these conflicts
###############################################################################

# Merging multiple data frames
all_data_2 <- plyr::join_all(
  list(
    bmx_data, sleep_data, paq_data, demo_data, dpq_data
  ), # datasets included in the merge
  by = "seqn", # unique identifier linking each dataset, i.e., study id
  type = "full", # type of match, this includes all observation regardless of missing
  match = "all"
) # default, matches all rows including duplicates``

# dim(all_data_2)
# str(all_data_2)

###############################################################################
#' Binding data frames, also referred to as stacking or appending
#' dplyr::bind_rows is a great way to bind
#' It has advantages over the rbinds base R methods because column order
#' does not matter with bind_rows()
###############################################################################

#' Import data frame we want to bind
#' Note: class data is the subfolder I store my nsly_wide1 and 2 datasets
nlsy_data1 <- rio::import(here::here("Modules", "Module3", "nlsy_wide1.dta"))
nlsy_data2 <- rio::import(here::here("Modules", "Module3", "nlsy_wide2.dta"))

nlsy_full_data <- dplyr::bind_rows(nlsy_data1, nlsy_data2)

# The .id is an optional argument that creates an indicator variable for each
# data frame. Here, i've decided to call it "wave", this is a user-selected
# label
nlsy_full_data2 <- dplyr::bind_rows(nlsy_data1, nlsy_data2,
  .id = "wave"
)

# print(nlsy_full_data2)
# head(nlsy_full_data)
# tail(nlsy_full_data)

###############################################################################
#' Sub-setting
#' This allows you to keep specific variables/columns or rows that satify a
#' condition
#' R contains lots of helper functions to customize your selection
###############################################################################

# example of using a helper function, selecting all variables with the dmd
# prefix
bmx_data2 <- all_data %>%
  select(starts_with("dmd"))

# str(bmx_data2)

#' retaining all rows that satisfy your conditions (20+ years of age)
some_data <- all_data_2 %>%
  dplyr::select(bmi, age, gender) %>%
  dplyr::filter(age >= 20)

# Recreatign the subset for future class examples
some_data <- all_data_2 %>%
  dplyr::filter(age >= 20)


# dim(demo_bmi_data)
# str(demo_bmi_data)
# head(demo_bmi_data)

###############################################################################
#' Pivoting or reshaping data frames
#' converts data from wide to long or long to wide
#' In this example, I use the reshape function, which is a base R function
#' The textbook provides an example of functions using the tidyr package
#' which we did not cover in class.
#'
#' Reshape works well for me so I use it more often. I encourage you to try
#' using tidyr rehaping functions on your own
###############################################################################

# print(nlsy_full_data)

# Converting tv variable to long format
nlsy_long_data <- nlsy_full_data %>%
  reshape(
    direction = "long", # indicates the direction of the pivot
    varying = c("tv1", "tv2", "tv3"), # the time-varying variables to pivot
    timevar = "visit", # distinguishes multiple records for same individual
    v.names = "tv" # names of variables in the long format that correspond to multiple variables in the wide format
  ) %>%
  arrange(pubid) # sorts by a specific variable, helps for verifying the reshape worked


# checking to see if the reshape worked
# nlsy_long_data[1:20, ]

#' here is an example for rehshpaing multiple variable
#' Note, the rehshape is organize by visit not variable
#' That means first state all the visit 1 variables you want to rehape,
#' then visit 2, etc.
nlsy_long_data <- reshape(nlsy_full_data,
  direction = "long",
  varying = c(
    "tv1", "weight1", "tv2", "weight2",
    "tv3", "weight3"
  ),
  timevar = "visit",
  v.names = c("tv", "weight")
) %>%
  dplyr::select(!id)

# nlsy_full_data[1:20, ]
# print(nlsy_long_data)

# Transforming for wide to long
nlsy_wide_data <- nlsy_long_data %>%
  reshape(
    timevar = "visit", # name of repeated measure indicator
    idvar = c("pubid", "sex", "race"), # fixed variables
    direction = "wide" # direction of the pivot/reshape
  )

# print(nlsy_wide_data)


###############################################################################

###############################################################################

# provide column with a tidyselect helper function
nlsy_long_data <- nlsy_full_data %>%
  pivot_longer(
    cols = starts_with("tv"),
    names_to = "tv",
    values_to = "hours"
  )
