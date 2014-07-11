# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# Returns a list whose first element is allFilteredData (data.frame), and second
loadFilteredData <- function() {
  allFilteredData <- read.csv("//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/filteredGpspoints.csv")
  uniqueFiles <- unique(subset(allFilteredData, select=c(sampn,perno)))
  return(list(allFilteredData=allFilteredData,uniqueFiles=uniqueFiles))
}

computeHeading <- function(firstX, firstY, secondX, secondY) {
  run <- secondX - firstX
  rise <- secondY - firstY
  heading <- atan2(rise, run)
  deg <- heading * (180 / pi)
  return((450 - deg) %% 360)
}