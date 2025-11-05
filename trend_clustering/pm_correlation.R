library(openair)
library(tidyverse)


data = read_rds("data/monthly_averages_10_years.rds")

sites_for_clustering = read_csv("data/sites_for_clustering.csv")


data_wide = sites_for_clustering %>%
  left_join(data) %>%
  select(date, site, pm2.5) %>%
  pivot_wider(names_from = site, 
              values_from = pm2.5)

test = data_wide %>%
  select(date, Aberdeen, `London N. Kensington`)

corPlot(data_wide, 
        dendrogram = TRUE)

### hourly

hourly_data = read_rds("C:/Users/Lucy Brown/OneDrive - University of York/Documents/DEFRA PDRA/-Defra/global/data/1994_2024_all_sites.rds")
a = selectByDate(hourly_data, 
                 year = 2014:2024)

hourly_wide = sites_for_clustering %>%
  left_join(hourly_data) %>%
  select(date, site, pm2.5) %>%
  pivot_wider(names_from = site, 
              values_from = pm2.5)


corPlot(hourly_wide, 
        dendrogram = TRUE)
