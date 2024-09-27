########################################
# Matthew Praestgaard
# 26 September 2024
# R script containing code for homework 1. Packages are loaded and installed first, then vectors are created and put into a data frame

# loading required packages for rmd output
require(knitr)
require(rmdformats)
knitr::opts_chunk$set(error = TRUE)

# loading packages used in homework
install.packages("ggplot2")
install.packages("dplyr")

library(ggplot2)
library(dplyr)

# Task 2: Creating Different Object Types
# Creating numeric vector "my_numbers"

my_numbers <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# Creating vector of my five favorate colors

my_colors <- c("green", "blue", "red", "purple", "orange")

# Creating data frame of name, age, and grade

name <- c("Guiseppe", "MargaretThatcher", "Theodore")
age <- c(22, 87, 19)
grade <- c("sophomore", "senior", "junior")

student_info <- data.frame(name, age, grade)
