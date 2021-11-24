library(sf)             # spatial data classes
## Linking to GEOS 3.5.1, GDAL 2.1.3, PROJ 4.9.2
library(rnaturalearth)  # world map data
library(readxl)         # reading excel files
library(dplyr)          # data manipulation
## 
## Attaching package: 'dplyr'
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
library(tidyr)          # data manipulation
library(purrr)          # data manipulation
library(cartogram)      # cartograms creation
library(tmap)           # maps creation

# DL spatial data
world.map = ne_countries(returnclass = "sf")
summary(world.map)
# DL tabular data
# if(!dir.exists("data")) dir.create("data")
# download.file("http://gapm.io/dl_pop", destfile = "data/pop1800_2100.xlsx")
world.pop = read_xlsx("data/pop1800_2100.xlsx", sheet = 7)
world.tab = readr::read_csv("./data/prevalence-of-undernourishment.csv")
world.tab <- world.tab %>% select("Country Name", "Country Code", "Time", "Value")
world.tab <- world.tab %>% rename("name"="Country Name")
world.tab <- world.tab %>% rename("iso3"="Country Code")
world.tab <- world.tab %>% rename("year"="Time")
world.tab <- world.tab %>% rename("deaths"="Value")

# world.map
world.map = world.map %>% 
  select(sovereignt) %>% 
  filter(sovereignt != "Antarctica") %>% 
  st_transform(world.map, crs = "+proj=robin")

tail(world.map) # 176
library(stringr)
bgr <- world.tab %>% filter(str_detect(name, "Bulgaria"))
# bgr
