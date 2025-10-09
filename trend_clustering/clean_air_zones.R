library(tidyverse)


city = c(
  "Aberdeen",
  "Bath",
  "Birmingham",
  "Bristol",
  "Bradford",
  "Dundee",
  "Edinburgh",
  "Glasgow",
  "London",
  "Oxford",
  "Newcastle",
  "Portsmouth",
  "Sheffield",
  "Southampton",
  "York"
)


CAZ_category = c(
  "D",
  "C",
  "D",
  "D",
  "C",
  "D",
  "D",
  "D",
  "D",
  "ZEZ",
  "C",
  "B",
  "C",
  "B",
  "A"
)

df = data.frame(city, CAZ_category)

write_csv(df, 
          file = "data/clean_air_zomes.csv")
