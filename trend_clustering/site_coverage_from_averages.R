library(tidyverse)
library(openair)

data = read_rds("data/yearly_averages_10_years.rds")


site_numbers = data %>%
  group_by(site) %>%
  summarise(o3_count = sum(!is.na(o3)),
            nox_count = sum(!is.na(nox)),
            pm2.5_count = sum(!is.na(pm2.5)))

count_cols = site_numbers %>% 
  select(ends_with("_count")) %>% 
  names()
            
results = map_dfr(1:10, function(threshold) {
  n_sites <- site_numbers %>%
    filter(if_all(all_of(count_cols), ~ . > threshold)) %>%
    nrow()
  
  tibble(threshold = threshold, n_sites = n_sites)
}) %>%
  mutate(years_of_good_coverage = threshold + 1)


results %>%
  ggplot(aes(x = years_of_good_coverage, y = n_sites)) +
  geom_point() +
  labs(x = "years with good coverage",
       y = "number of sites to be analysed") +
  scale_x_continuous(n.breaks = 11) +
  scale_y_continuous(n.breaks = 7) +
  theme_bw()



### chosen 5

sites_for_analysis = site_numbers %>%
    filter(if_all(all_of(count_cols), ~ . > 4)) 

site_list = sites_for_analysis %>%
  select(site)

write_csv(site_list, 
          file = "data/sites_for_clustering.csv")
