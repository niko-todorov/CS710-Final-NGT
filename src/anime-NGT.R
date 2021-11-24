library(pacman,quietly=TRUE,warn.conflicts=FALSE) # ,verbose=FALSE)
pacman::p_unload(pacman::p_loaded(), character.only = TRUE)

# Load libraries
library(dplyr,quietly=TRUE,warn.conflicts=FALSE)        # data wrangling
library(cartogram,quietly=TRUE,warn.conflicts=FALSE)    # for the cartogram
library(ggplot2,quietly=TRUE,warn.conflicts=FALSE)      # to realize the plots
library(broom,quietly=TRUE,warn.conflicts=FALSE)        # from geospatial format to data frame
library(tweenr,quietly=TRUE,warn.conflicts=FALSE)       # to create transition dataframe between 2 states
# devtools::install_github('thomasp85/gganimate')
# library(gganimate,quietly=TRUE,warn.conflicts=FALSE)    # To realize the animation
library(sp,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     
library(sf,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     
library(maptools,quietly=TRUE,warn.conflicts=FALSE,verbose=FALSE)     # world boundaries coordinates
library(viridis,quietly=TRUE,warn.conflicts=FALSE)      # for a nice color palette

# Get the shape file of Africa
data(wrld_simpl)
# afr=wrld_simpl[wrld_simpl$REGION==2,]
afr=spTransform(wrld_simpl[wrld_simpl$REGION==2,],CRS("+init=epsg:3395"))
# A basic representation
# plot(afr)


# construct a cartogram using the population in 2005
afr_cartogram <- cartogram_cont(afr, "POP2005", itermax=7)

# A basic representation
plot(afr_cartogram)


# Transform these 2 objects in dataframe, plotable with ggplot2
afr_cartogram_df <- tidy(afr_cartogram) %>% left_join(. , afr_cartogram@data, by=c("id"="ISO3")) 
afr_df <- tidy(afr) %>% left_join(. , afr@data, by=c("id"="ISO3")) 

# And using the advices of chart #331 we can custom it to get a better result:
ggplot() +
  geom_polygon(data = afr_df, aes(fill = POP2005/1000000, x = long, y = lat, group = group) , size=0, alpha=0.9) +
  theme_void() +
  scale_fill_viridis(name="Population (M)", breaks=c(1,50,100, 140), guide = guide_legend( keyheight = unit(3, units = "mm"), keywidth=unit(12, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1)) +
  labs( title = "Africa", subtitle="Population per country in 2005" ) +
  ylim(-35,35) +
  theme(
    text = element_text(color = "#22211d"), 
    plot.background = element_rect(fill = "#f5f5f4", color = NA), 
    panel.background = element_rect(fill = "#f5f5f4", color = NA), 
    legend.background = element_rect(fill = "#f5f5f4", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 13, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    legend.position = c(0.2, 0.26)
  ) +
  coord_map()

# You can do the same for afr_cartogram_df

# Give an id to every single point that compose the boundaries
afr_cartogram_df$id <- seq(1,nrow(afr_cartogram_df))
afr_df$id <- seq(1,nrow(afr_df))

# Bind both map info in a data frame. 3 states: map --> cartogram --> map
data <- rbind(afr_df, afr_cartogram_df, afr_df)

# Set transformation type + time
data$ease <- "cubic-in-out"
data$time <- rep(c(1:3), each=nrow(afr_df))

# Calculate the transition between these 2 objects?
dt <- tween_elements(data, time='time', group='id', ease='ease', nframes = 30)

# check a few frame
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==0) %>% arrange(order), 
  aes(fill = POP2005, x = long, y = lat, group = group), size=0, alpha=0.9
  )
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==5) %>% arrange(order), 
  aes(fill = POP2005, x = long, y = lat, group = group) , size=0, alpha=0.9
  )
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==10) %>% arrange(order), 
  aes(fill = POP2005, x = long, y = lat, group = group) , size=0, alpha=0.9
  )

# Make the animation with gganimate
# The last step consists at building the 30 maps and compile them in a .gif file. 
# This is done using the gganimate library. This library uses another 
# aesthetic: frame. A new plot is made for each frame, that allows us to build 
# the gif afterwards.

# Plot
p <- ggplot() + 
  geom_polygon(data = dt  %>% arrange(order) , aes(fill = POP2005/1000000, x = long, y = lat, group = group, frame=.frame) , size=0, alpha=0.9) +
  theme_void() +
  
  scale_fill_viridis(
    name="Population (M)", breaks=c(1,50,100, 140), 
    guide = guide_legend( 
      keyheight = unit(3, units = "mm"), keywidth=unit(12, units = "mm"), 
      label.position = "bottom", title.position = 'top', nrow=1)
  ) +
  labs( title = "Africa", subtitle="Population per country in 2005" ) +
  ylim(-35,35) +
  
  theme(
    text = element_text(color = "#22211d"), 
    plot.background = element_rect(fill = "#f5f5f4", color = NA), 
    panel.background = element_rect(fill = "#f5f5f4", color = NA), 
    legend.background = element_rect(fill = "#f5f5f4", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 13, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    legend.position = c(0.2, 0.26)
  ) +
  coord_map()

# Make the animation
animation::ani.options(interval = 1/9)
# gganimate(p, "Animated_Africa.gif",  title_frame = F)
gg_animate(p, "Animated_Africa.gif",  title_frame = F)



