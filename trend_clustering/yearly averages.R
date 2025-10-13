library(tidyverse)
library(openair)


data = read_rds("../global/data/1994_2024_all_sites.rds")

a = selectByDate(data, 
                 year = 2014:2024)

averages = timeAverage(a,
                  avg.time = "year",
                  data.thresh = 85,
                  type = "site")

write_rds(averages, 
          file = "data/yearly_averages_10_years.rds")



 ############# monthly


b = selectByDate(data, 
                 year = 2014:2024)

monthly_averages = timeAverage(b,
                       avg.time = "month",
                       data.thresh = 85,
                       type = "site")

write_rds(monthly_averages, 
          file = "data/monthly_averages_10_years.rds")
