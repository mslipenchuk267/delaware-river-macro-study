# Load Libs -------------------------------------------------------------------
library(dplyr)
library(stringr)

# Load Data -------------------------------------------------------------------
taxonomy_table <- read.csv(file.path(getwd(), "data", "taxonomy_table.csv"))

# Get Species Data ------------------------------------------------------------
taxonomy_table <- taxonomy_table %>% 
  mutate(taxonomy = paste(phylum, class, sub_class, order, family, sep = " ")) %>% 
  mutate(taxonomy = trimws(taxonomy, whitespace = "[ ]")) %>% 
  mutate(taxonomy = str_squish(taxonomy)) %>% 
  relocate(taxonomy, .after = family)

# Save Species data -----------------------------------------------------------
write.csv(taxonomy_table,
          file = file.path(getwd(), "data", "taxonomy_table.csv"), 
          row.names = FALSE)
