library(openair)
library(tidyverse)
library(ggpubr)
library(sf)         
library(ggplot2)     
library(rnaturalearth)       
library(rnaturalearthdata)  


data = read_rds("data/monthly_averages_10_years.rds")
meta = importMeta(source = "aurn")
sites = read_csv("data/sites_for_clustering.csv")
clusters = read_csv("data/clusters.csv")


correlations = sites %>%
  left_join(data) %>%
  group_by(site) %>%
  filter(sum(complete.cases(o3, pm2.5)) >= 2) %>%  # keep only groups with ≥2 valid pairs
  summarise(correlation = cor(o3, pm2.5, use = "complete.obs")) %>%
  ungroup() %>%
  left_join(clusters)

correlations %>%
  ggplot(aes(y = correlation, x = cluster)) +
  geom_point(aes(colour = cluster)) +
  scale_colour_manual(values = cluster_colours) +
  theme_minimal() +
  labs(title = "ozone and PM2.5",
       y = "correlation coefficient")
