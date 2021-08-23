# Download the necessary packages
list.of.packages <- c("ggplot2","tidyverse","tidyr","cartogram","maptools","packcircles","rgdal","rgeos","sf","sp")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load required R packages
library(ggplot2)
library(tidyr)
# library(tidyverse)
# library()
library(cartogram)
library(maptools)
library(rgdal)
library(rgeos)
library(readr)
library(sf)
library(sp)

# IMPORT world map data
data(wrld_simpl)

# IMPORT world death of COVID-19 time series
deaths_global <- read_csv("dat/time_series_covid19_deaths_global.csv")
View(deaths_global)

# IMPORT world countries ISO lookup table
LookUp <- read_csv("dat/UID_ISO_FIPS_LookUp_Table.csv")
View(LookUp)

# IMPORT world happiness table
happiness <- read_csv("dat/happinessdata.csv")
mid <- mean(happiness$Year)
ggplot(happiness,aes(x=Economy,y=HappinessScore,color=Year))+
  geom_point() +
  scale_color_gradient2(midpoint=mid,low="blue",mid="white",
                        high="red",space="Lab")

ggplot(data <- happiness, mapping <- aes(x<-Health, y<-as.factor(Region), fill<-as.factor(Year))) + geom_violin(trim=TRUE) + geom_boxplot(width=0.1) # geom_point() # geom_contour
#ggplot(happiness,aes(x=Economy,y=HappinessScore,color=Region))+geom_point() + geom_encircle()

