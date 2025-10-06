library(openair)
library(tidyverse)

one_site = importAURN(site = "my1", year = 2022,
                      meta = TRUE)


## calculate yearly average ozone 

yearly_avg = timeAverage(one_site, 
                         avg.time = "year",
                         data.thresh = 85,
                         type = "site") %>%
  select(site, date, o3)

write_csv(yearly_avg, 
          file = "data/yearly_average_o3_by_site.csv")
