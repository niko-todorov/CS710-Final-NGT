# CS-710 Spring 2021
# Final Project
# Niko Grisel Todorov

# Install the necessary packages
library(pacman,quietly=TRUE,warn.conflicts=FALSE)
pacman::p_unload(pacman::p_loaded(),character.only=TRUE)

# Install R Environment
# if (!requireNamespace("remotes")) install.packages("remotes")
# remotes::install_github("rstudio/renv")

my.packages <- c("dplyr","cartogram","ggplot2","tidyr","maptools","rgdal","sf","sp")
install.packages(setdiff(my.packages, rownames(installed.packages())))

# Load required R packages
library(dplyr,quietly=TRUE,warn.conflicts=FALSE)        # data wrangling
library(cartogram,quietly=TRUE,warn.conflicts=FALSE)    # for the cartogram
library(ggplot2,quietly=TRUE,warn.conflicts=FALSE)      # to realize the plots
library(tidyr,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)
library(sp,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     
options("rgdal_show_exportToProj4_warnings"="none")
library(rgdal,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)
library(sf,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     
library(readr,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)
# library(maptools,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE) # world map
library(rnaturalearth,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)  # world map
library(viridis,quietly=TRUE,warn.conflicts=FALSE)      # for nice colors

# 1. IMPORT world map data
world.map <- ne_countries(returnclass="sf")
# 1.2. remove extraneous columns 
world.map <- world.map %>% select(sovereignt) %>% 
  # 1.3. exclude no data countries
  filter(sovereignt != "Antarctica") %>% 
  # filter(sovereignt != "North Korea") %>% 
  filter(sovereignt != "Northern Cyprus") %>% 
  filter(sovereignt != "Somaliland") %>% 
  filter(sovereignt != "Turkmenistan") %>%
  filter(sovereignt != "Western Sahara") %>% 
  # filter(sovereignt != "France") %>% 
  # filter(sovereignt != "Denmark") %>% 
  # filter(sovereignt != "Israel") %>% 
  # filter(sovereignt != "United Kingdom") %>% 
  # filter(sovereignt != "United States of America") %>% 
  # 1.4. transform and project https://proj.org/operations/projections/
  st_transform(world.map, crs="+proj=robin") # Robinson or Mollweide
# world.map <- world.map %>% distinct(sovereignt, .keep_all = TRUE)
# summary(world.map)
# world.map$sovereignt
plot(world.map)

# fr <- world.map %>% select(sovereignt) %>% filter(sovereignt == "France")
# dk <- world.map %>% select(sovereignt) %>% filter(sovereignt == "Denmark")
# il <- world.map %>% select(sovereignt) %>% filter(sovereignt == "Israel")
# uk <- world.map %>% select(sovereignt) %>% filter(sovereignt == "United Kingdom")
# us <- world.map %>% select(sovereignt) %>% filter(sovereignt == "United States of America")

# plot(fr) # 3 dups, remove -1st,-3rd
# plot(dk) # 2 dups, remove -?
# plot(il) # 2 dups, remove -2nd
# plot(uk) # 2 dups, remove -1st
# plot(us) # 2 dups, remove -1st

# world.map %>% select(sovereignt) %>% filter(sovereignt=="France" | sovereignt=="Denmark" | sovereignt=="Israel" | sovereignt=="United Kingdom" | sovereignt=="United States of America")

# duplicated(world.fin$sovereignt)==TRUE # 54, 56, 64, 112, 130, 163
# world.fin$sovereignt[duplicated(world.fin$sovereignt)] # 11!

# 2. IMPORT COVID-19 world death time series
world.tab <- readr::read_csv("dat/COVID-19-DEATHS-WORLD.csv",show_col_types = FALSE)

# 3. death data adjusting and cleaning
world.tab <- world.tab %>% mutate(sovereignt = Country) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Congo (Kinshasa)", "Democratic Republic of the Congo")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Congo (Brazzaville)", "Republic of Congo")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Bahamas", "The Bahamas")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Slovak Republic", "Slovakia")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Czechia", "Czech Republic")) %>%   
  mutate(sovereignt=replace(sovereignt,sovereignt=="Serbia", "Republic of Serbia")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="North Macedonia", "Macedonia")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Cote d'Ivoire", "Ivory Coast")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="US", "United States of America")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="Taiwan*", "Taiwan")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Burma", "Myanmar")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Korea, South", "South Korea")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Tanzania", "United Republic of Tanzania")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Guinea-Bissau", "Guinea Bissau")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Eswatini", "Swaziland")) %>%
  mutate(sovereignt=replace(sovereignt,sovereignt=="Timor-Leste", "East Timor")) %>% 
  mutate(sovereignt=replace(sovereignt,sovereignt=="West Bank and Gaza", "Palestine"))

# 4. JOIN map and data
world.fin <- left_join(world.map, world.tab, by = "sovereignt") %>% na.omit()
# which(names(world.fin)=="1/22/2020") # 3
# which(names(world.fin)=="8/21/2021") # 580
# world.fin <- world.fin %>% 
# world.map = st_as_sf(world.map)

# a sample cartogram
world.fin.beg = world.fin %>% select(sovereignt, 580) # "1/22/2020" "8/21/2021"
# which(names(world.fin.beg)=="1/22/2020")
world.carto.1 = cartogram_cont(world.fin.beg, weight="8/21/2021", itermax=15, maxSizeError=1.5)
plot(world.carto.1, col = sf.colors(20, categorical = TRUE), border="grey", axes = FALSE)
# plot(world.carto.1)

# 5. LOOP (and save) over each date col to cartogram it 
world.fin %>% select(sovereignt,3:580)

world.fin$indicator="deaths"
tail(world.fin)

