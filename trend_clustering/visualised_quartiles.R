
library(tidyverse)
library(openair)


trends = read_csv("data/annual_trends.csv")


nox_cut = cutData(trends, type = "nox_slope") %>%
  select(site, nox_slope) %>%
  mutate(nox_slope = str_replace_all(nox_slope, "nox_slope -29 to -2.73", "4")) %>%
  mutate(nox_slope = str_replace_all(nox_slope, "nox_slope -2.73 to -1.94", "3")) %>%
  mutate(nox_slope = str_replace_all(nox_slope, "nox_slope -1.94 to -1.24", "2")) %>%
  mutate(nox_slope = str_replace_all(nox_slope, "nox_slope -1.24 to -0.196", "1"))
  


o3_cut = cutData(trends, type = "o3_slope") %>%
  select(site, o3_slope) %>%
  mutate(o3_slope = str_replace_all(o3_slope, "o3_slope 1.09 to 2.86", "4")) %>%
  mutate(o3_slope = str_replace_all(o3_slope, "o3_slope 0.867 to 1.09", "3")) %>%
  mutate(o3_slope = str_replace_all(o3_slope, "o3_slope 0.549 to 0.867", "2")) %>%
  mutate(o3_slope = str_replace_all(o3_slope, "o3_slope 0.125 to 0.549", "1"))
  


pm2.5_cut = cutData(trends, type = "pm2.5_slope") %>%
  select(site, pm2.5_slope) %>%
  mutate(pm2.5_slope = str_replace_all(pm2.5_slope, "pm2.5_slope -0.695 to -0.505", "4")) %>%
  mutate(pm2.5_slope = str_replace_all(pm2.5_slope, "pm2.5_slope -0.505 to -0.387", "3")) %>%
  mutate(pm2.5_slope = str_replace_all(pm2.5_slope, "pm2.5_slope -0.387 to -0.236", "2")) %>%
  mutate(pm2.5_slope = str_replace_all(pm2.5_slope, "pm2.5_slope -0.236 to -0.0572", "1"))


cuts = nox_cut %>%
  left_join(o3_cut) %>%
  left_join(pm2.5_cut) %>%
  drop_na(pm2.5_slope) 

totals = cuts %>%
  mutate(nox_slope = as.numeric(nox_slope),
         o3_slope = as.numeric(o3_slope),
         pm2.5_slope = as.numeric(pm2.5_slope),
         total = nox_slope + o3_slope + pm2.5_slope) 

category_colors <- c(
  "1" = "blue1",
  "2" = "skyblue1",
  "3" = "rosybrown1",
  "4" = "red1"
)

cuts %>%
  pivot_longer(cols = c(nox_slope, o3_slope, pm2.5_slope),
               names_to = "poll",
               values_to = "slope_category",
               names_pattern = "(.*)_slope") %>%
  left_join(totals) %>%
  ggplot(aes(x = poll, y = reorder(site, total))) +
  geom_point(aes(colour = slope_category), shape = 15, size = 5) +
  scale_colour_manual(values = category_colors) +
    labs(colour = "strength of trend",
         x = "pollutant",
         y = "site",
         subtitle = "Thiel-Sen Trend over 10 years") +
  theme_minimal()



library(sf)         
library(ggplot2)     
library(rnaturalearth)       
library(rnaturalearthdata)   

sites = read_csv("data/sites_for_clustering.csv")

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

sites_sf <- sites_with_meta %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)  # WGS84

(site_map = ggplot(data = uk_map) +
    geom_sf(fill = "gray90", color = "white") +
    geom_sf(data = sites_sf, aes(color = pm2.5_slope), size = 2) +
    coord_sf(xlim = c(-8, 2), ylim = c(49.5, 59), expand = FALSE) +
    scale_colour_manual(values = category_colors) +
#    labs(
#      title = "Sites for Clustering Analysis",
#      color = "Site Type"
#    ) +
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



comp = trends %>%
  left_join(start_concentration)


comp %>%
  ggplot(aes(x = pm2.5, 
             y = pm2.5_slope)) +
  geom_point() +
  labs(x = "starting concentration of pm2.5",
       y = "trend over 10 years") +
  theme_minimal() +
  stat_cor(label.x.npc = 0.6)
