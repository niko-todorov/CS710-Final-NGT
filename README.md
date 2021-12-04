## Spring 2021 CS-710
## Advanced Visualization Class
## Final Project
## Niko Grisel Todorov

## Description

#  COVID-19 a once in a 100-year world pandemic event 
# has affected the lives of most planetary inhabitants.
# This project aims to dynamically visualize the spread
# of the virus and more specifically daily mortality counts
# by country as collected and reported by Jons Hopkins University.
# My aim was to create not just a world-wide choropleth map,
# but to distort the countries shapes based on the daily 
# mortality and aggregate those daily cartograms into an 
# animated GIF or video to show the spread of the virus 
# and mortality by country. The data preparation and clean up 
# is commented in the R source code as well as in multiple 
# SQL queries that are stored in the ACCDB file, also checked in.
# The tabular data for this project includes 580 days from the
# very 1st day COVID-19 was reported 1/22/2020 to 8/21/2021.

# The spatial data was based on rnaturalearth R package and 
# projected in Robinson and Mollweide world projections
# best suited to represent the cartogram map in my opinion.

# Further, removed Antarctica, North Korea, Northern Cyprus,
# Somaliland, Turkmenistan, Western Sahara for no reported data.

# The following countries France (3), Denmark (2), Israel (2), United 
# Kingdom (2), United States of America (2) were represented with 
# multi-feature polygons and were simplified. The tabular and spatial
# data country spelling discrepancies were addressed for:

# Bahamas to The Bahamas
# Slovak Republic to Slovakia
# Czechia to Czech Republic  
# Serbia to Republic of Serbia
# North Macedonia to Macedonia
# Cote d'Ivoire to Ivory Coast
# US to United States of America
# Taiwan* to Taiwan
# Burma to Myanmar
# Korea, South to South Korea
# Tanzania to United Republic of Tanzania
# Guinea-Bissau to Guinea Bissau
# Eswatini to Swaziland
# Timor-Leste to East Timor
# West Bank and Gaza to Palestine

# The directory tree structure is as follows:
# src -- Source code
# dat -- Data folder
# doc -- Documents folder
# img -- Images folder

## Instructions
1. Open CS710-Final-NGT.Rproj in RStudio
2. Run Final-NGT.R
3. The PNG images will be in the img dir


### Vaccination Data

Please find the JHU COVID-19 vaccination data hosted on the 
[JHU GovEx GitHub repository](https://github.com/govex/COVID-19/tree/master/data_tables/vaccine_data). This repository includes both our 
[global vaccination sources](https://github.com/govex/COVID-19/blob/master/data_tables/vaccine_data/global_data/readme.md) and 
[US vaccination sources](https://github.com/govex/COVID-19/blob/master/data_tables/vaccine_data/us_data/readme.md).

