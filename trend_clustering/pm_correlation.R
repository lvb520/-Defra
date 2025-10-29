library(openair)


data = read_rds("data/monthly_averages_10_years.rds")

sites_for_clustering = read_csv("data/sites_for_clustering.csv")


data_wide = sites_for_clustering %>%
  left_join(data) %>%
  select(date, site, pm2.5) %>%
  pivot_wider(names_from = site, 
              values_from = pm2.5)

test = data_wide %>%
  select(date, Aberdeen, `London N. Kensington`)

corPlot(data_wide, 
        dendrogram = TRUE)
