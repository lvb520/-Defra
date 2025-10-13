library(openair)
library(tidyverse)


data = read_rds("data/monthly_averages_10_years.rds")

corPlot(data, 
        pollutants = c("pm2.5", 
                       "co",
                       "no", 
                       "nox",
                       "no2",
                       "so2",
                       "longitude",
                       "latitude",
                       "o3"
                       ),
        type = "season",
        cluster = TRUE)
