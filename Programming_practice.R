################################################################################
#' Below is a sample R script
#' Identify the issues and modify the code as necessary
################################################################################

# Load libraries
library(ggplot2)

# Read Data
data=read.csv('data.csv')

# Data Cleaning
data$Age = as.integer(data$Age)
data$Gender = as.factor(data$Gender)
data=data[data$Age>18,]
data=data[data$Gender %in% c('Male','Female'),]

# Plotting Data
p=ggplot(data, aes(x=Age, fill=Gender)) + geom_bar() + labs(title = 'Age Distribution by Gender') + xlab('Age') + ylab('Count')
print(p)
