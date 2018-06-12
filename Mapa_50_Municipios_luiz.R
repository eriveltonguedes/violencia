# Código original criado por Luiz Eduardo Gomes
#
##==============================================================================
## Install and load packages
##==============================================================================

# install.packages("install.load")

if (!require("install.load")) install.packages("install.load")
install.load::install_load("leaflet", "maptools", "rgdal", "tidyverse","spdep","cartography","tmap","RColorBrewer")


#############################################################################
#Lendo os dados
#############################################################################
setwd("~/../ownCloud/AtlasViolencia/2018")


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

state_popup <- paste0("<strong>Estado: </strong>",
                      brasilpg$uf,
                      "<br><strong>Taxa: </strong>",
                      round(brasilpg$taxas,2))
leaflet(data = brasilpg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(brasilpg$taxas),
              fillOpacity = 0.8,
              color = "#BDBDC3",
              weight = 1,
              popup = state_popup) %>%
  addScaleBar("bottomright") %>%
  addLegend("topright", pal = pal, values = ~brasilpg$taxas,
            title = "Taxa de Homicidios",
            opacity = 1)
# addPolylines(mapaUF) %>%