library(tidyverse)
library(openair)

data = read_rds("data/yearly_averages_10_years.rds")


site_numbers = data %>%
  group_by(site) %>%
  summarise(o3_count = sum(!is.na(o3)),
            nox_count = sum(!is.na(nox)),
            pm2.5_count = sum(!is.na(pm2.5)))
            
