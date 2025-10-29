library(openair)
library(tidyverse)


data = read_rds("../global/data/1994_2024_all_sites.rds")

a = selectByDate(data, 
                 year = 2014:2024)

sites = read_csv("data/sites_for_clustering.csv")

clusters = read_csv("data/clusters.csv") %>%
  filter(!site == "London Marylebone Road")

cluster_data = sites%>%
  left_join(clusters) %>%
  left_join(a)

timeVariation(cluster_data, 
              pollutant = c("pm2.5", "nox"),
              type = "cluster")
