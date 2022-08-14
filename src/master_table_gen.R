# Load in Libraries -----------------------------------------------------------
library(dplyr)
library(ggplot2)
library(stringr)

# Load in Data ----------------------------------------------------------------
site_table <- read.csv(file.path(getwd(), "data", "8_6_2022", "site_table.csv"))
macro_table <- read.csv(file.path(getwd(), "data", "8_6_2022", "macro_table.csv"))
tolerance_table <- read.csv(file.path(getwd(), "data", "raw", "tolerance_table.csv"))

# Merge
master_table <- macro_table %>% left_join(site_table %>% select(-site), by = c("site" = "id"))  
master_table <- master_table %>% left_join(tolerance_table %>% select(-id),
                                           by = c("name" = "name", "taxonomy" = "taxonomy"))  
# Format
master_table <- master_table %>% 
  mutate(date_time = as.POSIXct(paste(date, time), format = "%m/%d/%Y %I:%M %p")) %>% 
  relocate(date_time, .after = time)

# Save master table
write.csv(master_table,
          file = file.path(getwd(), "data", "master_table.csv"), 
          row.names = FALSE)
