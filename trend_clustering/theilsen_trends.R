library(openair)
library(tidyverse)


data = read_rds("data/yearly_averages_10_years.rds")
sites = read_csv("data/sites_for_clustering.csv")


cluster_data = sites %>%
  left_join(data)


nox_trends = TheilSen(cluster_data,
         pollutant = "nox",
         type = "site",
         avg.time = "year",
         slope.percent = TRUE)

nox_results = nox_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>%
  select(site, p.stars, slope.percent, lower.percent, upper.percent) %>%
  rename(nox_p.stars = p.stars, 
         nox_slope= slope.percent, 
         nox_lower = lower.percent,
         nox_upper = upper.percent)


o3_trends = TheilSen(cluster_data,
                      pollutant = "o3",
                      type = "site",
                      avg.time = "year",
                     slope.percent = TRUE)

o3_results = o3_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>% 
  select(site, p.stars, slope.percent, lower.percent, upper.percent) %>%
  rename(o3_p.stars = p.stars, 
         o3_slope= slope.percent, 
         o3_lower = lower.percent,
         o3_upper = upper.percent)



pm2.5_trends = TheilSen(cluster_data,
                     pollutant = "pm2.5",
                     type = "site",
                     avg.time = "year",
                     slope.percent = TRUE)

pm2.5_results = pm2.5_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>% 
  select(site, p.stars, slope.percent, lower.percent, upper.percent) %>%
  rename(pm2.5_p.stars = p.stars, 
         pm2.5_slope= slope.percent, 
         pm2.5_lower = lower.percent,
         pm2.5_upper = upper.percent)


trends = nox_results %>%
  left_join(o3_results) %>%
  left_join(pm2.5_results)


write_csv(trends, 
          "data/annual_trends_percent.csv")

################## monthly seasonal


month_data = read_rds("data/monthly_averages_10_years.rds")
sites = read_csv("data/sites_for_clustering.csv")


cluster_data = sites %>%
  left_join(month_data)


nox_trends = TheilSen(cluster_data,
                      pollutant = "nox",
                      type = c("site", "season"))

nox_results = nox_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>%
  select(site, season, p.stars, slope, lower, upper) %>%
  rename(nox_p.stars = p.stars, 
         nox_slope= slope, 
         nox_lower = lower,
         nox_upper = upper)


o3_trends = TheilSen(cluster_data,
                     pollutant = "o3",
                     type = c("site", "season"))

o3_results = o3_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>% 
  select(site, season, p.stars, slope, lower, upper) %>%
  rename(o3_p.stars = p.stars, 
         o3_slope= slope, 
         o3_lower = lower,
         o3_upper = upper)



pm2.5_trends = TheilSen(cluster_data,
                        pollutant = "pm2.5",
                        type = c("site", "season"))

pm2.5_results = pm2.5_trends$data[[2]] %>% # slope is trend per year, lower and upper are 95% CI of the slope
  drop_na(slope) %>% 
  select(site, season, p.stars, slope, lower, upper) %>%
  rename(pm2.5_p.stars = p.stars, 
         pm2.5_slope= slope, 
         pm2.5_lower = lower,
         pm2.5_upper = upper)


trends = nox_results %>%
  left_join(o3_results) %>%
  left_join(pm2.5_results)


write_csv(trends, 
          "data/seasonal_trends.csv")

