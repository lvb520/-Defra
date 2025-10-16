
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

category_colors <- c(
  "1" = "blue1",
  "2" = "skyblue1",
  "3" = "rosybrown1",
  "4" = "red1"
)

cuts %>%
  pivot_longer(cols = c(nox_slope, o3_slope, pm2.5_slope),
               names_to = "poll",
               values_to = "slope_category") %>%
  mutate(total = no)
  ggplot(aes(x = poll, y = site)) +
  geom_point(aes(colour = slope_category), shape = 15, size = 5) +
  scale_colour_manual(values = category_colors) +
  theme_minimal()
