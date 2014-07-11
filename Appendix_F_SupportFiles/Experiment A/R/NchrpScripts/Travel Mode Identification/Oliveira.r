# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# Precondition - Initialize.r is run

getOliveiraSegments <- function(segments, data) { 
  segments$minspeedmph <- getAggregateColumn(min, 'speedmph', data, segments)
  segments$maxspeedmph <- getAggregateColumn(max, 'speedmph', data, segments)
  segments$avgspeedmph <- getAggregateColumn(mean, 'speedmph', data, segments)
  segments$sdspeedmph <- getAggregateColumn(sd, 'speedmph', data, segments)
  
  segments$minaccelmps2 <- getAggregateColumn(min, 'accelmps2', data, segments)
  segments$maxaccelmps2 <- getAggregateColumn(max, 'accelmps2', data, segments)
  segments$avgaccelmps2 <- getAggregateColumn(mean, 'accelmps2', data, segments)
  segments$sdaccelmps2 <- getAggregateColumn(sd, 'accelmps2', data, segments)
  
  #segments$distancemiles <- mapply(getDeltaDistanceMetersBetweenAdjacent, 
  #                                 data$long[segments$startindex:segments$endindex], 
  #                                 data$lat[segments$startindex:segments$endindex]) * 0.000621371
  
  segments$distancemiles <- mapply(function(start, end) { sum(getDeltaDistanceMetersBetweenAdjacent(data$long[start:end], data$lat[start:end]) * 0.000621371) },
                                   segments$startindex, 
                                   segments$endindex)
  return(segments)
}

exportSegments <- function(segments, filename) {
  # move travmode to end
  travmodeindex <- grep("travmode", names(segments))
  tripsexport <- segments[,c((1:ncol(segments))[-travmodeindex], travmodeindex)]
  # We use "" instead of NA so that WEKA can cope with it
  write.table(tripsexport,file=filename,sep=",",row.names=F, quote=FALSE, na="")  
}

pointsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/test90points.csv"
segmentsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/test90.csv"
segmentsAndDataList <- readModeSegmentReferenceData(segmentsFilename, pointsFilename)
segments <- segmentsAndDataList[[1]]
data <- segmentsAndDataList[[2]]
segments <- getOliveiraSegments(segments, data)
filename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/OliveiraTrainingData/test90ForMNL.csv"
exportSegments(segments, filename)

pointsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/train180points.csv"
segmentsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/train180.csv"
segmentsAndDataList <- readModeSegmentReferenceData(segmentsFilename, pointsFilename)
segments <- segmentsAndDataList[[1]]
data <- segmentsAndDataList[[2]]
segments <- getOliveiraSegments(segments, data)
filename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/OliveiraTrainingData/train180ForMNL.csv"
exportSegments(segments, filename)
