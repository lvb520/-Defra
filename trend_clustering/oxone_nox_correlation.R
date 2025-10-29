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

cluster_colours = c(
  "A" = "#ef476f",
  "B" = "#F78C6B",
  "C" = "#FFD166",
  "D" = "#06D6A0",
  "E" = "#118AB2",
  "F" = "#073B4C"
)


correlations = sites %>%
  left_join(data) %>%
  group_by(site) %>%
  filter(sum(complete.cases(nox, o3)) >= 2) %>%  # keep only groups with ≥2 valid pairs
  summarise(correlation = cor(nox, o3, use = "complete.obs")) %>%
  ungroup() %>%
  left_join(clusters)

correlations %>%
  ggplot(aes(y = correlation, x = cluster)) +
  geom_point(aes(colour = cluster)) +
  scale_colour_manual(values = cluster_colours) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "ozone and NOx",
       y = "correlation coefficient")


sites_with_meta = correlations %>%
  left_join(meta)


uk_map <- ne_countries(scale = "medium", country = "United Kingdom", returnclass = "sf")

sites_sf <- sites_with_meta %>%
  filter(site_type == "Urban Background") %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)  # WGS84

(site_map = ggplot(data = uk_map) +
    geom_sf(fill = "gray90", color = "white") +
    geom_sf(data = sites_sf, aes(color = correlation), size = 4) +
    coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
    scale_colour_distiller(palette = "RdBu") +
    theme_minimal())
