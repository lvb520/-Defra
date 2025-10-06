library(tidyverse)


data = read_rds("data/1994_2024_all_sites.rds")

### number of sites with any measurement of ozone

number_of_obs = data %>%
  group_by(site) %>%
  summarise(non_na_o3 = sum(!is.na(o3)))

count_non_na_groups = number_of_obs %>%
  filter(non_na_o3 > 0) %>%
  tally()  

print(count_non_na_groups)
