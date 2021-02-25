library(ggmap)
library(dplyr)
library(mongolite)

source("scripts/id_gen.R")
source("scripts/keys.R")


register_google(key = my_key())
#print(login())

#need a google api key and access to mongodb for access to up to date info.
uri <- paste("mongodb+srv://" , login() , "@geoffcluster-3sd9t.azure.mongodb.net/", sep = "") 
places_d <- mongo(collection = "places", url = uri )

geo_address <- function (addy) {
  result <- geocode(addy)
  lon <- as.numeric(result[1])
  lat <- as.numeric(result[2])
  return(c(lon,lat))
}

places <- places_d$find()

add_restroom <- function (name, address) {
  latlong <- geo_address(address)
  long <- latlong[1]
  lat <- latlong[2]
  result <- data.frame("name"= name, "address" = address,"long" = long, "lat" = lat, 
                       rest_id = get_random("RR", places))
  places_d$insert(places)
  places <<- places_d$find()
}
