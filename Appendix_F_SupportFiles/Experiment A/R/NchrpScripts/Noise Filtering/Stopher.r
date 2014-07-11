# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# Remove zero-speed and low movement (< 15 m distance)
noiseFiltering_Stopher <- function(dataFrame) {
  deltaDistanceMeters <- c(0, getDeltaDistanceMetersBetweenAdjacent(dataFrame$long, dataFrame$lat))
  deltaHeading <- c(0, dataFrame[2:nrow(dataFrame), "heading"] - dataFrame[1:(nrow(dataFrame)-1), "heading"])
  dataFrame$noise <- 
    (dataFrame$nbsat < 3 | dataFrame$hdop >= 5) | 
    (dataFrame$speedmph == 0 & deltaDistanceMeters < 15 & 
       (dataFrame$heading == 0 | deltaHeading == 0))
  return(dataFrame)
}