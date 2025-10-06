library(openair)
library(tidyverse)


data = read_rds("data/1994_2024_all_sites.rds")

filtered_data = data %>%
  filter(site_type %in% c("Urban Background", "Urban Traffic", "Rural Background"))

TheilSen(filtered_data, pollutant = "o3",
         avg.time = "month",
         date.breaks = 6,
         date.format = "%Y",
         type = c("site_type", "season"))
