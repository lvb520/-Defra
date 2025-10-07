library(tidyverse)
library(openair)
library(sf)         
library(ggplot2)     
library(rnaturalearth)       
library(rnaturalearthdata)   

sites = read_csv("data/sites_for_clustering.csv")


meta = importMeta(source = "aurn")


sites_with_meta = sites %>%
  left_join(meta)


uk_map <- ne_countries(scale = "medium", country = "United Kingdom", returnclass = "sf")

sites_sf <- sites_with_meta %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)  # WGS84

(site_map = ggplot(data = uk_map) +
  geom_sf(fill = "gray90", color = "white") +
  geom_sf(data = sites_sf, aes(color = site_type), size = 2) +
  coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Sites for Clustering Analysis",
    color = "Site Type"
  ) +
  theme_minimal())

ggsave(site_map,
       filename = "plots/sites_for_clustering_map.png", 
       device = "png")

