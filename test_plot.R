library(dplyr)
library(sinimr)
library(sf)
library(tmap)

reg13 <- read_sf("https://raw.githubusercontent.com/robsalasco/precenso_2016_geojson_chile/master/Extras/GRAN_SANTIAGO.geojson")

comunas <- c("CERRILLOS", "LA REINA", "PUDAHUEL", "CERRO NAVIA", "LAS CONDES",
             "QUILICURA", "CONCHALÍ", "LO BARNECHEA", "QUINTA NORMAL", "EL BOSQUE",
             "LO ESPEJO", "RECOLETA", "ESTACIÓN CENTRAL", "LO PRADO", "RENCA", "HUECHURABA",
             "MACUL", "SAN MIGUEL", "INDEPENDENCIA", "MAIPÚ", "SAN JOAQUÍN", "LA CISTERNA", "ÑUÑOA",
             "SAN RAMÓN", "LA FLORIDA", "PEDRO AGUIRRE CERDA", "SANTIAGO", "LA PINTANA", "PEÑALOLÉN",
             "VITACURA", "LA GRANJA", "PROVIDENCIA", "SAN BERNARDO", "PUENTE ALTO", "PADRE HURTADO", "PIRQUE",
             "SAN JOSÉ DE MAIPO")

var <- getsinimr(882, 2017) %>% filter(MUNICIPALITY %in% comunas)

var[3] <- var[3]*1000

var.reg13.join <- reg13 %>%
  select(COMUNA) %>% 
  transmute(CODE = as.character(COMUNA)) %>%
  right_join(var, by=c("CODE"))

reg.13.plot <- tm_shape(var.reg13.join) +
  tm_polygons(names(var.reg13.join)[3], palette="magma", border.col = "white") +
  tm_text(names(var.reg13.join)[2], size = 0.4, style="jenks") +
  tm_legend(legend.position = c("left", "top")) +
  tm_compass(type = "8star", position = c("right", "top")) +
  tm_scale_bar(breaks = c(0, 10), size = 0.75, position = c("right", "bottom"), width = 1) +
  tm_credits("Fuente: Sistema Nacional de Información Municipal (SINIM), SUBDERE, Ministerio del Interior.", position=c("left", "bottom"), size=0.55)

tmap_save(reg.13.plot + tm_layout(inner.margins = c(0.1, 0.1, 0.10, 0.01)), 
          "plot.png", width=8, height=8, dpi = 300, units = "in")
