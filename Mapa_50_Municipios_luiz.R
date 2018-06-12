# Código original criado por Luiz Eduardo Gomes
#
##==============================================================================
## Install and load packages
##==============================================================================

# install.packages("install.load")

if (!require("install.load")) install.packages("install.load")
if (!require("install.load")) install.packages("maptools")
if (!require("install.load")) install.packages("spdep")
if (!require("install.load")) install.packages("cartography")
if (!require("install.load")) install.packages("RColorBrewer")
if (!require("install.load")) install.packages("tmap")
if (!require("install.load")) install.packages("leaflet")
if (!require("install.load")) install.packages("mapproj")
if (!require("install.load")) install.packages("rgdal")
if (!require("install.load")) install.packages("tidyverse")


library(tidyverse, warn.conflicts = F)
library(mapproj, warn.conflicts = F)
library(markdown, warn.conflicts = F)
library(leaflet, warn.conflicts = F)
library(rgdal, warn.conflicts = F)
library(tidyverse, warn.conflicts = F)
library(maptools, warn.conflicts = F)
library(spdep, warn.conflicts = F)
library(cartography, warn.conflicts = F)
library(RColorBrewer, warn.conflicts = F)
# library(tmap, warn.conflicts = F)

#############################################################################
#Lendo os dados
#############################################################################
setwd("~/../ownCloud/AtlasViolencia/2018")


# Importando shapefile (mapa do Brasil)----
# Carregando os pacotes----

library(maptools)    
library(spdep)         
library(cartography)   
library(tmap)          
library(leaflet)       
library(dplyr)
library(rgdal)
library(dplyr)
library(RColorBrewer)

# Importando shapefile (mapa do Brasil)----

brasil <- readOGR("municipios_2010.shp",
                  stringsAsFactors=FALSE, encoding="UTF-8")

class(brasil)

mapaUF = readOGR("estados_2010.shp")

# Importando dataset----

pg <- read.csv2("teste_mun_BA.csv",
                header = TRUE,sep=";")

pg <- data.frame(codmunic = pg$codmunic, taxas = pg$taxa.2016)

names(brasil@data)[8] <- "codmunic"

brasilpg <- merge(brasil,pg, by = "codmunic")

#Tratamento e transformação dos dados----

proj4string(brasilpg) <- CRS("+proj=longlat +datum=WGS84 +no_defs") #adicionando coordenadas geográficas

Encoding(brasilpg$nome) <- "UTF-8"

brasilpg$taxas[is.na(brasilpg$taxas)] <- 0 #substituindo NA por 0

# Gerando o mapa----

# display.brewer.all()

pal <- colorBin("YlOrRd",domain = NULL,n=5) #cores do mapa
pal2 <- colorBin("White",domain = NULL,n=5) #cores do mapa

state_popup <- paste0("<strong>Estado: </strong>",
                      brasilpg$uf,
                      "<br><strong>Taxa: </strong>",
                      round(brasilpg$taxas,2))
leaflet(data = brasilpg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  # addPolygons(fillColor = ~pal2(mapaUF$id),
  #             fillOpacity = 0.8,
  #             color = "#ffffff",
  #             weight = 1) %>%
  
  addPolygons(fillColor = ~pal2(brasilpg$taxas),
              fillOpacity = 0.1,
              color = "#ffffff",
              weight = 1,
              popup = state_popup) %>%
  addScaleBar("bottomright") %>%
  addLegend("topright", pal = pal, values = ~brasilpg$taxas,
            title = "Taxa de Homicidios",
            opacity = 1)

#color = "#BDBDC3" -> amarela
#color = "#ffffff" -> branca

# addPolylines(mapaUF) %>%
