
library(openair)
library(sf)         
library(ggplot2)     
library(rnaturalearth)       
library(rnaturalearthdata)   
library(tidyverse)
library(ggpubr)

sites = read_csv("data/sites_for_clustering.csv")
cuts = read_csv("data/quartile_trends.csv")
trends_percent = read_csv("data/annual_trends_percent.csv")
trends_abs = read_csv("data/annual_trends.csv")

start_concentration = read_rds("data/yearly_averages_10_years.rds") %>%
  drop_na(pm2.5) %>%
  select(site, date, pm2.5) %>%
  group_by(site) %>%
  filter(date == min(date))

meta = importMeta(source = "aurn")


sites_with_meta = sites %>%
  left_join(meta) %>%
  left_join(cuts) %>%
  left_join(start_concentration)


uk_map <- ne_countries(scale = "medium", country = "United Kingdom", returnclass = "sf")

category_colors <- c(
  "1" = "blue1",
  "2" = "skyblue1",
  "3" = "rosybrown1",
  "4" = "red1"
)

sites_sf <- sites_with_meta %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>% # WGS84
  mutate(pm2.5_slope = as.character(pm2.5_slope))
(site_map = ggplot(data = uk_map) +
    geom_sf(fill = "gray90", color = "white") +
    geom_sf(data = sites_sf, aes(color = pm2.5_slope), size = 2) +
    coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
    scale_colour_manual(values = category_colors) +
        labs(
          color = "strength of trend"
       ) +
    theme_minimal())


(site_map = ggplot(data = uk_map) +
    geom_sf(fill = "gray90", color = "white") +
    geom_sf(data = sites_sf, aes(color = pm2.5), size = 2) +
    coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
    scale_colour_distiller(palette = "RdBu") +
    #scale_colour_manual(values = category_colors) +
    #    labs(
    #      title = "Sites for Clustering Analysis",
    #      color = "Site Type"
    #    ) +
    theme_minimal())



comp = trends_abs %>%
  left_join(start_concentration)


comp %>%
  ggplot(aes(x = pm2.5, 
             y = pm2.5_slope)) +
  geom_point() +
  labs(x = "starting concentration of pm2.5",
       y = "absolute trend over 10 years") +
  theme_minimal() +
  stat_cor(label.x.npc = 0.6)
