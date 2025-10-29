library(tidyverse)
library(openair)


data = read_rds("data/monthly_averages_10_years.rds")
clusters = read_csv("data/clusters.csv") %>%
  filter(!site == "London Marylebone Road")


data = clusters %>%
  left_join(data) %>%
  pivot_longer(cols = c(pm2.5, nox, o3),
               names_to = "pollutant",
               values_to = "monthly_mean")

cluster_colours = c(
  "A" = "#ef476f",
  "B" = "#F78C6B",
  "C" = "#FFD166",
  "D" = "#06D6A0",
  "E" = "#118AB2",
  "F" = "#073B4C"
)

data %>%
  ggplot(aes(x = cluster, y = monthly_mean)) +
  geom_boxplot(aes(colour = cluster)) +
  facet_wrap(~pollutant, scales = "free_y") +
  theme_bw() +
  scale_colour_manual(values = cluster_colours)


data %>%
  filter(cluster == "D") %>%
  filter(pollutant == "nox") %>%
  ggplot(aes(x = site, y = monthly_mean)) +
  geom_boxplot(aes(colour = cluster)) +
  scale_colour_manual(values = cluster_colours) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  