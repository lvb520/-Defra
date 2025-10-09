library(tidyverse)
library(openair)

meta = importMeta(source = "aurn")

trends = read_csv("data/annual_trends.csv") %>%
  left_join(meta)

trends %>%
  ggplot(aes(x = reorder(site, latitude), y = nox_slope, ymin = nox_lower, ymax = nox_upper)) +
  geom_pointrange() +
  geom_hline(yintercept = 1) +
  coord_flip() +
  theme_minimal()
