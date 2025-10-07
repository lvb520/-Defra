library(openair)
library(tidyverse)


data = read_rds("../global/data/1994_2024_all_sites.rds")


cut_data = cutData(data, 
                   type = "o3",
                   n.levels = 10)

urban_traffic = data %>%
  filter(site_type == "Urban Traffic")

cut_urban_traffic = cutData(urban_traffic,
                            type = "o3",
                            n.levels = 10)

urban_background = data %>%
  filter(site_type == "Urban Background")

cut_urban_background = cutData(urban_background,
                            type = "o3",
                            n.levels = 10)

rural_background = data %>%
  filter(site_type == "Rural Background")

cut_rural_background = cutData(rural_background,
                               type = "o3",
                               n.levels = 10)
