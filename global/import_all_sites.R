library(openair)

meta = importMeta(source = "aurn")

site_list = meta$code

data_all <- importAURN(site = site_list, year = 1994:2024, meta = TRUE)  

saveRDS(data_all, 
        file = "data/1994_2024_all_sites.rds")