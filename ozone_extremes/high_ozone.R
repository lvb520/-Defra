library(openair)
library(tidyverse)


data = read_rds("../global/data/1994_2024_all_sites.rds")

o3_concs = data %>%
  select(site, date, o3)


cut_data = cutData(data, 
                   type = "o3",
                   n.levels = 10)

urban_traffic = data %>%
  filter(site_type == "Urban Traffic")

cut_urban_traffic = cutData(urban_traffic,
                            type = "o3",
                            n.levels = 10) %>%
  filter(o3 == "o3 60.1 to 328")

urban_background = data %>%
  filter(site_type == "Urban Background")

cut_urban_background = cutData(urban_background,
                            type = "o3",
                            n.levels = 10) %>%
  filter(o3 == "o3 74 to 280")

rural_background = data %>%
  filter(site_type == "Rural Background")

cut_rural_background = cutData(rural_background,
                               type = "o3",
                               n.levels = 10) %>%
  filter(o3 == "o3 84 to 278")

top_10_percent = cut_urban_traffic %>%
  bind_rows(cut_urban_background) %>%
  bind_rows(cut_rural_background) %>%
  rename(o3_category = o3) %>%
  left_join(o3_concs)
