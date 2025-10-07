library(openair)
library(tidyverse)


data = read_rds("data/yearly_averages_10_years.rds")
sites = read_csv("data/sites_for_clustering.csv")


cluster_data = sites %>%
  left_join(data)


