library(tidyverse)
library(openair)
library(sf)         
library(ggplot2)     
library(rnaturalearth)       
library(rnaturalearthdata)  



sites = read_csv("data/sites_for_clustering.csv")
meta = importMeta(source = "aurn")
clusters = read_csv("data/clusters.csv")

df = sites %>%
  left_join(meta) %>%
  left_join(clusters)

uk_map <- ne_countries(scale = "medium", country = "United Kingdom", returnclass = "sf")

sites_sf <- df %>%
  #filter(site_type == "Urban Background") %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)  # WGS84

cluster_colours = c(
  "A" = "#ef476f",
  "B" = "#F78C6B",
  "C" = "#FFD166",
  "D" = "#06D6A0",
  "E" = "#118AB2",
  "F" = "#073B4C"
)

(site_map = ggplot(data = uk_map) +
    geom_sf(fill = "gray90", color = "white") +
    geom_sf(data = sites_sf, aes(color = cluster), size = 4) +
    coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
    scale_colour_manual(values = cluster_colours) +
    theme_minimal())

