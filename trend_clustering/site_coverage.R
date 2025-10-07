library(tidyverse)
library(openair)


data = read_rds("../global/data/1994_2024_all_sites.rds")

a = selectByDate(data, 
                 year = 2014:2024)

nox = timeAverage(a,
                  avg.time = "year",
                  data.thresh = 85,
                  type = "site")


write_rds(nox, 
          file = "data/yearly_averages_10_years.rds")
