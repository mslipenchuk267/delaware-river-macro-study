# Load in Libraries
library(dplyr)
library(ggplot2)
# Load in Data

site_table <- read.csv(file.path(getwd(), "data", "site_table.csv"))
macro_table <- read.csv(file.path(getwd(), "data", "macro_table.csv"))


# Visualize Site Information
# TODO: keep chronological order on x axis
ggplot(site_table, aes(x = id, y = cond)) + 
  geom_bar(stat="identity") +
  ggtitle("Conductivity") +
  ylab("μS") + xlab("Site ID")


