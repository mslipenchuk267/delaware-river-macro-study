# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

# Load libraries
library(dplyr)
library(ggplot2)
library(ggrepel)

# Set Global Plot theme
theme_set(theme_bw())

# Set Params
STUDY_DATE <- "8_6_2022"
EXCLUSION_SITES <- c("DRRR1", "DRRPP3")

# -----------------------------------------------------------------------------
# Get Data
# -----------------------------------------------------------------------------
# Load Data
site_table <- read.csv(file.path(getwd(), "data", STUDY_DATE, 
                                 "site_table.csv"))
site_h_table <- read.csv(file.path(getwd(), "data", STUDY_DATE, 
                                   "site_h_table.csv"))
site_easton_dist_table <- read.csv(file.path(getwd(), "data", STUDY_DATE, 
                                             "site_easton_dist_table.csv"))

# Format Data
site_table <- site_table %>% 
  mutate(land_use = as.factor(land_use),
         substrate = as.factor(substrate))

# Join Data
site_table <- site_table %>% left_join(site_h_table, 
                                       by = c("id" = "site"))
site_table <- site_table %>% left_join(site_easton_dist_table, 
                                       by = c("id" = "site"))

# Filter out Excluded Data
site_table <- site_table %>% filter(id != EXCLUSION_SITES)

# Get Train and Test Set
training_set <- c("DRRSU2", "DRRSU4", "DRRR7", "DRRR9")
test_set <- c("DRRSU3", "DRRU5", "DRRSU8", "DRRU11")
train_table <- site_table %>% filter(id %in% training_set)
test_table <- site_table %>% filter(id %in% test_set)

# -----------------------------------------------------------------------------
# Fit Model
# -----------------------------------------------------------------------------
h_lm <- lm(H ~ cond + do_mgL + land_use + distance_mi, data = site_table)

summary(h_lm)
#plot(h_lm)

# Get Prediction --------------------------------------------------------------
site_table <- site_table %>% 
  mutate(pred = predict(h_lm),
         raw_error = H - pred,
         abs_raw_error = abs(H - pred))

# -----------------------------------------------------------------------------
# View Model Results
# -----------------------------------------------------------------------------
output_prefix <- paste("h_value_prediction_", STUDY_DATE, ".png")

# View Prediction
ggplot(site_table) + 
  geom_point(aes(x=factor(label = id, x = id), y=H), fill = "chartreuse1", size = 3, shape = 21) +
  geom_point(aes(x=factor(label = id, x = id), y=pred), fill = "darkorchid1", size = 3, shape = 22) +
  geom_text_repel(aes(x=factor(label = id, x = id), y=H, label=round(H, 3)),  direction ="both") +
  geom_text_repel(aes(x=factor(label = id, x = id), y=pred, label=paste(round(pred, 3), "err:", round(error, 3))), box.padding = 1, direction ="both") +
  labs(title='H Prediction Model (Real: Green, Pred: Purple)',
       y='H Value', 
       x='Site')

ggsave(file.path(getwd(), "output", paste("h_value_prediction_", STUDY_DATE, ".png")), 
       width = 8, height = 5)

# View Error
ggplot(site_table, aes(x=factor(label = id, x = id), y=error)) + 
  geom_bar(stat = "identity", fill = "salmon", alpha = 0.8) +
  geom_hline(yintercept = 0) +
  geom_text(aes(label=round(error, 3)), vjust=-0.5) +
  labs(title='H Prediction Model Error',
       y='H Value', 
       x='Site')

ggsave(file.path(getwd(), "output", paste("h_value_model_error_", STUDY_DATE, ".png")), 
       width = 8, height = 5)
