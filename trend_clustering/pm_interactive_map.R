library(openairmaps)
library(tidyverse)

data = read_rds("C:/Users/lvb520/OneDrive - University of York/Documents/DEFRA PDRA/-Defra/global/data/1994_2024_all_sites.rds")

a = selectByDate(data, 
                 year = 2014:2024)

clusters = read_csv("data/clusters.csv") %>%
  filter(!site == "London Marylebond Road")

mydata = clusters %>%
  left_join(a)
  

polarMap(mydata, pollutant = "pm2.5",
         type = "cluster")
