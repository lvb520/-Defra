library(openair)
library(tidyverse)

meta = importMeta(source = "aurn")

site_list = meta$code

data_all <- importAURN(site = site_list, year = 1994:2024, meta = TRUE)  

saveRDS(data_all, 
        file = "data/1994_2024_all_sites.rds")

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


### plotting


yearly_avg %>%
  left_join(meta) %>%
  drop_na(o3) %>%
  ggplot(aes(x = date, y = o3, colour = site)) +
  facet_wrap(~site_type) +
  geom_line(show.legend = FALSE)
