library(openair)
library(tidyverse)


data = read_rds("data/yearly_averages_10_years.rds")
sites = read_csv("data/sites_for_clustering.csv")


cluster_data = sites %>%
  left_join(data)


nox_trends = TheilSen(cluster_data,
         pollutant = "nox",
         type = "site",
         avg.time = "year")

nox_results = nox_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope)


o3_trends = TheilSen(cluster_data,
                      pollutant = "o3",
                      type = "site",
                      avg.time = "year")

o3_results = o3_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope)



pm2.5_trends = TheilSen(cluster_data,
                     pollutant = "pm2.5",
                     type = "site",
                     avg.time = "year")

pm2.5_results = pm2.5_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope)
