library(openair)
library(tidyverse)
library(lubridate)


data = read_rds("../global/data/1994_2024_all_sites.rds")

yearly_means = read_csv("data/yearly_average_o3_by_site.csv")

o3_concs = data %>%
  select(site, date, o3)


urban_traffic = data %>%
  filter(site_type == "Urban Traffic")

cut_urban_traffic = cutData(urban_traffic,
                            type = "o3",
                            n.levels = 100) %>%
  filter(o3 == "o3 86 to 328")

urban_background = data %>%
  filter(site_type == "Urban Background")

cut_urban_background = cutData(urban_background,
                            type = "o3",
                            n.levels = 100) %>%
  filter(o3 == "o3 104 to 280")

rural_background = data %>%
  filter(site_type == "Rural Background")

cut_rural_background = cutData(rural_background,
                               type = "o3",
                               n.levels = 100) %>%
  filter(o3 == "o3 112 to 278")

top_1_percent = cut_urban_traffic %>%
  bind_rows(cut_urban_background) %>%
  bind_rows(cut_rural_background) %>%
  rename(o3_category = o3) %>%
  left_join(o3_concs)

TheilSen(top_1_percent, pollutant = "o3",
         avg.time = "month",
         date.breaks = 6,
         date.format = "%Y",
         layout = c(1,3),
         type = c("site_type"))



### as ratios

yearly_means = yearly_means %>%
  mutate(year = lubridate::year(date)) %>%
  select(site, year, o3) %>%
  rename(annual_mean_o3 = o3)

ratios = top_1_percent %>%
  mutate(year = lubridate::year(date)) %>%
  left_join(yearly_means) %>%
  mutate(ratio = o3/annual_mean_o3,
         percent = 100*o3/annual_mean_o3,
         percent_difference_from_mean = 100*(o3-annual_mean_o3)/annual_mean_o3)

TheilSen(ratios, pollutant = "percent_difference_from_mean",
         avg.time = "month",
         date.breaks = 6,
         date.format = "%Y",
         layout = c(1,3),
         y.relation = "free",
         type = c("site_type"))
