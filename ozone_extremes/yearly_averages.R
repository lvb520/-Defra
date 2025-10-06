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
