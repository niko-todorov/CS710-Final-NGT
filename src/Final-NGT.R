# CS-710 Spring 2021
# Final Project
# Niko Grisel Todorov

# Install the necessary packages
library(pacman,quietly=TRUE,warn.conflicts=FALSE)
pacman::p_unload(pacman::p_loaded(),character.only=TRUE)
my.packages <- c("dplyr","cartogram","ggplot2","tidyr","rgdal","sf","sp","readr","rnaturalearth","viridis","purrr","tmap")
install.packages(setdiff(my.packages, rownames(installed.packages())))

# Install R Environment
# if (!requireNamespace("remotes")) install.packages("remotes")
# remotes::install_github("rstudio/renv")

# Load required R packages
library(dplyr,quietly=TRUE,warn.conflicts=FALSE)        # data wrangling
library(cartogram,quietly=TRUE,warn.conflicts=FALSE)    # for the cartogram
library(ggplot2,quietly=TRUE,warn.conflicts=FALSE)      # to do the plots
library(tidyr,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)  # data manipulation
options(rgdal_show_exportToProj4_warnings="none")
library(sp,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     # spatial
library(rgdal,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)  # R geo data abs lyr
library(sf,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     # spatial features
library(readr,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)  # data manipulation
library(rnaturalearth,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)  # world map
library(viridis,quietly=TRUE,warn.conflicts=FALSE)      # for nice colors
library(purrr,quietly=TRUE,warn.conflicts=FALSE)        # data manipulation
library(tmap,quietly=TRUE,warn.conflicts=FALSE)         # maps creation
# 1. IMPORT world map data
world.map <- ne_countries(returnclass="sf")
# 1.2. remove extraneous columns 
world.map <- world.map %>% select(sovereignt) %>% 
  # 1.3. exclude no data countries
  filter(sovereignt != "Antarctica") %>% 
  filter(sovereignt != "North Korea") %>%
  filter(sovereignt != "Northern Cyprus") %>% 
  filter(sovereignt != "Somaliland") %>% 
  filter(sovereignt != "Turkmenistan") %>%
  filter(sovereignt != "Western Sahara") %>% 
  # 1.4. transform and project https://proj.org/operations/projections/
  st_transform(world.map, crs="+proj=moll") # robin Robinson or moll Mollweide

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

# a sample cartogram
png(file="img//COVID040.png", width = 1600, height = 1024)
world.beg = world.fin %>% select(sovereignt, 580) # "2/28/2020"
world.carto = cartogram_cont(world.beg, weight=2, itermax=15)
plot(world.carto, pal=viridis, border="grey", axes=FALSE) 
dev.off()

# world.fin$indicator="deaths"
# tail(world.fin) # 166

# 5. LOOP over (and save) each day's data to cartogram it 
inc <- 100 # experiment
beg <- which(names(world.fin)=="2/28/2020") # 40
end <- which(names(world.fin)=="8/21/2021") # 580
for (i in seq(beg,end,inc)) {
  print(paste("day: ", as.character(i))) # , " date ", names(world.fin$i)
  # compute daily totals
  world.loop <- world.fin %>% select(sovereignt, i)
    # %>% mutate(daily.total = sum(as.numeric(value), na.rm = TRUE)) 
    # %>% mutate(title = paste0("date: ", day, "\nTotal COVID-19 deaths (x1000): ", round(daily.total/1e3, 2)))

  world.carto = cartogram_cont(world.loop, weight=2, itermax=15)
  # warning: this may make your computer's fan spin!
  # world.carto = world.loop %>% 
  #   purrr::map(cartogram_cont, 2, itermax=15, maxSizeError=1.5) %>% 
  #   do.call(rbind, .) 
  # carto.anim = tm_shape(world.carto) + tm_polygons("deaths") +
  #   tm_facets(along = "title", free.coords = FALSE, drop.units = TRUE)
  # tmap_animation(carto.anim, filename = "covid19-deaths-world.gif",
  #   delay = 75, width = 1326, height = 942)
  # tmap_arrange(world.carto, nrow = 1)  
  fname=sprintf("img//COVID%03d.png",i)
  png(file=fname, width = 1600, height = 1024)
  plot(world.carto, pal=viridis, border="grey", axes = FALSE)
  dev.off()
}

