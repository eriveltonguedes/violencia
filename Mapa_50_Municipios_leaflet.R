# Código original criado por André Vieira
#
##==============================================================================
## Install and load packages
##==============================================================================

# install.packages("install.load")

if (!require("install.load")) install.packages("install.load")
install.load::install_load("leaflet", "mapproj", "rgdal", "tidyverse")


#############################################################################
#Lendo os dados
#############################################################################
setwd("~/../ownCloud/AtlasViolencia/2018")

brasil <- readOGR("municipios_2010.shp")
dados <- read.csv2("teste_mun_BA.csv",header = TRUE,sep=";")

# Seleciona apenas municipios da BA
brasil <- subset(brasil, brasil$uf %in% "BA")

# Adiciona variaveis de violencia ao shape
brasil@data <- brasil@data %>% 
      dplyr::mutate(cod6 = as.integer(as.character(cod6))) %>%
      left_join(dados, by = c("cod6" = "codmunic"))

# Cria um mapa basico com Leaflet
leaflet(brasil) %>%
      addPolygons(data = brasil,
                  color = "#444444",
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0,
                  fillColor = ~colorQuantile("YlOrRd", homic.2016)(homic.2016),
                  label = ~Município.x,
                  highlightOptions = highlightOptions(color = "grey80", weight = 2,
                                                      bringToFront = TRUE))

# Prepara os dados em data.frame para criar o mapa com ggplot2
mapa_brasil_coord <- fortify(brasil, region = "id")
mapa_brasil_geral <- mapa_brasil_coord %>% 
      tbl_df %>% 
      dplyr::mutate(id = as.factor(id)) %>%
      left_join(brasil@data, by = "id")

# Cria um mapa basico com ggplot2
ggplot() + 
      geom_polygon(data = mapa_brasil_geral, aes(long, lat, 
                       group = group, fill = homic.2016),
                   color = "black", size = 0.25) + 
      coord_map() +
      scale_fill_distiller(palette = "Spectral") + 
      theme_void() 

