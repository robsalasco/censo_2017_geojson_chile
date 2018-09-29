library(dplyr)
library(sinimr)
library(geojsonsf)
library(sf)
library(tmap)

chl <- read_sf("Extras/CHILE3.geojson")

var <- getsinimr(882, 2017)

var[3] <- var[3]*1000

chl.join <- chl %>%
  select(COMUNA) %>% 
  transmute(CODE = as.character(sprintf("%05d",as.numeric(COMUNA)))) %>%
  left_join(var, by=c("CODE"))

tmap_mode("view")

tm_shape(chl.join) +
  tm_polygons(names(chl.join)[3], palette="magma", border.col = "white", style="jenks") +
  tm_layout(inner.margins = c(0.1, 0.1, 0.10, 0.01))



