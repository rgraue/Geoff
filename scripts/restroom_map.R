library(leaflet)
library(ggmap)


get_map <- function(){
  data <- read.csv("data/places.csv", stringsAsFactors = F)
  
  data <- data %>%
    mutate(desc = paste(name, address, sep = "<br/>"))
  
  map <- leaflet(data) %>%
    addProviderTiles(providers$MtbMap) %>%
    addProviderTiles(providers$Stamen.TonerLines,
                     options = providerTileOptions(opacity = 0.35)) %>%
    addProviderTiles(providers$Stamen.TonerLabels) %>%
    setView(-95.7129, 37.0902,  zoom = 4) %>%
    addMarkers(
      ~long,
      ~lat,
      clusterOptions = markerClusterOptions(),
      popup = ~as.character(desc)
    )
}
