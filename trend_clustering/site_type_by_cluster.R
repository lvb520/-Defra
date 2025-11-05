library(tidyverse)
library(openair)


clusters = read_csv("data/clusters.csv")
meta = importMeta(source = "aurn")

cluster_type = clusters %>%
  left_join(meta)

cluster_type %>%
  ggplot(aes(x = cluster, y = site_type)) +
  geom_count(shape = 1) +
  theme_bw()
