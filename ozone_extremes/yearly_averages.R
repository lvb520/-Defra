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


### plotting


yearly_avg %>%
  left_join(meta) %>%
  drop_na(o3) %>%
  ggplot(aes(x = date, y = o3, colour = site)) +
  facet_wrap(~site_type) +
  geom_line(show.legend = FALSE)
