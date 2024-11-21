# script to import CSV data set
require(tidyverse)
require(rio)
require(here)

diet <- rio::import(here("Homework3", "diet_data-2.csv"))

# inspecting data
dim(diet)
head(diet)
names(diet)
str(diet)

# creating data set with only adults GE 20 years old
dietAdult <- diet %>%
    filter(age >= 20)
dietKid <- diet %>%
    filter(age < 20)
