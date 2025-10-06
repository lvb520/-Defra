library(openair)
library(tidyverse)

meta = importMeta(source = "aurn")

site_list = meta$code

data_all <- importAURN(site = site_list, year = 1994:2024, meta = TRUE)  
one_site = importAURN(site = "my1", year = 2022,
                      meta = TRUE)


### calculate yearly average ozone 

yearly_avg = timeAverage(data_all, 
                         avg.time = "year",
                         data.thresh = 85,
                         type = "site") %>%
  select(site, date, o3)

write_csv(yearly_avg, 
          file = "data/yearly_average_o3_by_site.csv")


### plotting