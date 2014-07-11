# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

noiseFiltering_Lawson <- function(data) {
  satellitesBelow3 <- data$nbsat < 3
  hdopAbove5 <- data$hdop > 5
  speedBelow3 <- data$speedmps < 3
  
  # NOTE: Unclear if stopFlags just means it stopped or if they are actually meant for filtering
  len <- nrow(data)
  latStopFlags <- abs(data$lat[1:len-1] - data$lat[2:len]) < .00005
  longStopFlags <- abs(data$long[1:len-1] - data$long[2:len]) < .00005
  stopFlags <- c(FALSE, latStopFlags & longStopFlags)
  
  data$noise <- satellitesBelow3 | hdopAbove5 | speedBelow3 | stopFlags
  
  return(data)
}