library(tidyverse)
library(openair)
library(fuzzyjoin)

meta = importMeta(source = "aurn")
caz = read_csv("data/clean_air_zomes.csv")

trends = read_csv("data/annual_trends.csv") %>%
  left_join(meta)


CAZ_numbers = c(0, 1, 2, 3, 4)
CAZ_category = c("NA", "A", "B", "C", "D")

caz_numeric = data.frame(CAZ_numbers, CAZ_category)

caz = caz %>%
  left_join(caz_numeric)


trends_with_caz = regex_left_join(trends, caz, 
                                  by = c("site" = "city"),
                                  ignore_case = TRUE)

trends_long <- trends_with_caz %>%
  pivot_longer(
    cols = matches("_(slope|upper|lower|p.stars)$"),
    names_to = c("pollutant", ".value"),
    names_pattern = "(.*)_(slope|upper|lower|p.stars)"
  ) %>%
  mutate(CAZ_numbers = replace_na(CAZ_numbers, 0))



trends_with_caz %>%
  filter(site_type == "Urban Background") %>%
  ggplot(aes(x = reorder(site, latitude), y = o3_slope, ymin = o3_lower, ymax = o3_upper)) +
  geom_pointrange(aes(colour = CAZ_category)) +
  geom_hline(yintercept = 1) +
  coord_flip() +
  labs(x = "site by latitude") +
  theme_minimal()

trends_long %>%
  filter(slope > -20) %>%
  ggplot(aes(x = reorder(site, CAZ_numbers), y = slope, ymin = lower, ymax = upper)) +
  geom_pointrange(aes(colour = CAZ_category)) +
  geom_hline(yintercept = 0) +
  coord_flip() +
  labs(x = "site by CAZ category") +
  facet_wrap(~pollutant, scales = "free_x") +
  theme_minimal()


trends_long %>%
  left_join(trends) %>%
  #filter(site_type == "Rural Background") %>%
  filter(slope > -20) %>%
  ggplot(aes(x = reorder(site, o3_slope), y = slope, ymin = lower, ymax = upper)) +
  geom_pointrange(aes(colour = CAZ_category)) +
  geom_hline(yintercept = 0) +
  coord_flip() +
  labs(x = "site ordered by latitude") +
  facet_wrap(~pollutant, scales = "free_x") +
  theme_minimal()
