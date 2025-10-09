library(tidyverse)
library(openair)
library(fuzzyjoin)

meta = importMeta(source = "aurn")
caz = read_csv("data/clean_air_zomes.csv")

trends = read_csv("data/annual_trends.csv") %>%
  left_join(meta)


trends_with_caz = regex_left_join(trends, caz, 
                                  by = c("site" = "city"),
                  ignore_case = TRUE)

trends_long <- trends_with_caz %>%
  pivot_longer(
    cols = matches("_(slope|upper|lower|p.stars)$"),
    names_to = c("pollutant", ".value"),
    names_pattern = "(.*)_(slope|upper|lower|p.stars)"
  )



trends_with_caz %>%
  filter(site_type == "Urban Background") %>%
  ggplot(aes(x = reorder(site, latitude), y = o3_slope, ymin = o3_lower, ymax = o3_upper)) +
  geom_pointrange(aes(colour = CAZ_category)) +
  geom_hline(yintercept = 1) +
  coord_flip() +
  labs(x = "site by latitude") +
  theme_minimal()
