# Download the necessary packages
list.of.packages <- c("tidyverse","tidyr","ggplot2","cartogram","maptools","packcircles","rgdal","rgeos","sf")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load required R packages
library(cartogram)
library(maptools)
library(rgdal)
library(rgeos)
library(sf)
data(wrld_simpl)

#setwd("C:/GitHub/CS710-Final-NGT")