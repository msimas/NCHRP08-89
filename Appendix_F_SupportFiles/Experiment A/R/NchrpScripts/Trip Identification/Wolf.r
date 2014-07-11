# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

tripIdentification_Wolf <- function(data) {
  tripends <- which(data$deltaseconds >= 120) - 1 # high deltaseconds happens after a trip end (assumes points are filtered)
  
  # Add first index if necessary (it probably will be because deltaseconds of first point is always 0 unless points have been filtered)
  # Use 0 here because we're going to add 1 to the trip ends to get the trip starts
  if (!(0 %in% tripends)) {
    tripends <- c(0, tripends)
  }
  
  # Add last index if necessary
  if (!(nrow(data) %in% tripends)) {
    tripends <- c(tripends, nrow(data))
  }
  
  trips <- data.frame(
    gpstripid = 1:(length(tripends) - 1),
    startindex = tripends[1:(length(tripends) - 1)] + 1,
    endindex = tripends[2:length(tripends)]
  )
  
  trips$starttime <- data[trips$startindex, 'datetimeutc']
  trips$endtime <- data[trips$endindex, 'datetimeutc']
  trips$startlat <- data[trips$startindex, 'lat']
  trips$startlong <- data[trips$startindex, 'long']
  trips$endlat <- data[trips$endindex, 'lat']
  trips$endlong <- data[trips$endindex, 'long']
  
  trips$distancemeters <- NA
  trips$travtimeminutes <- round(difftime(trips$endtime, trips$starttime, units="mins"), digits = 2)
  for (index in 1:nrow(trips)) {
    trips[index, 'distancemeters'] <- round(sum(getDeltaDistanceMetersBetweenAdjacent(data[trips[index,'startindex']:trips[index,'endindex'], 'long'], data[trips[index,'startindex']:trips[index,'endindex'], 'lat'])), digits = 0);
  }
  trips$avgspeedkph <- round((trips$distancemeters / 1000) / as.numeric(trips$travtimeminutes / 60), digits = 2)
  
  return(trips)
}