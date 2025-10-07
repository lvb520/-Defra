library(openair)
library(tidyverse)

meta = importMeta(source = "aurn")

data_all = read_rds("data/1994_2024_all_sites.rds")

### calculate yearly average ozone 

yearly_avg = timeAverage(data_all, 
                         avg.time = "year",
                         data.thresh = 85,
                         type = "site") %>%
  select(site, date, o3)

write_csv(yearly_avg, 
          file = "data/yearly_average_o3_by_site.csv")

### checking number of sites with appropriate coverage

number_of_obs = yearly_avg %>%
  group_by(site) %>%
  summarise(non_na_o3 = sum(!is.na(o3)))

count_non_na_groups = number_of_obs %>%
  filter(non_na_o3 > 0) %>%
  tally()  

print(count_non_na_groups)

### number for each site type

number_of_obs = yearly_avg %>%
  left_join(meta) %>%
  group_by(site_type, site) %>%
  summarise(non_na_o3 = sum(!is.na(o3)), .groups = "drop") %>%  # count non-NA o3 per site
  filter(non_na_o3 > 0) %>%                                    # keep only sites with at least one non-NA o3
  group_by(site_type) %>%
  summarise(num_sites = n_distinct(site))


### plotting

## scatter plot
(yearly_scatter = yearly_avg %>%
  left_join(meta) %>%
  filter(site_type %in% c("Rural Background", "Urban Background", "Urban Traffic")) %>%
  drop_na(o3) %>%
  ggplot(aes(x = date, y = o3, colour = site)) +
  facet_wrap(~site_type) +
  geom_point(show.legend = FALSE) +
  theme_bw() +
  labs(y = expression("O"[3]*" (ppb)"),
       title = "yearly average ozone by site"))

ggsave(yearly_scatter,
       filename = "plots/yearly_avg_scatter.png",
       device = "png")

