# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# Precondition - Initialize.r has been run

travelModeIdentification_Gonzalez <- function(segmentsFilename, pointsFilename, outputFilename) {
  segmentsAndDataList <- readModeSegmentReferenceData(segmentsFilename, pointsFilename)
  segments <- segmentsAndDataList[[1]]
  data <- segmentsAndDataList[[2]]
  
  # including origin in standard deviation of distances between stop locations,
  # this is not explicit in the paper but is a reasonable thing to do
  # Expects stops variable to be already defined
  getStandardDeviationOfDistanceBetweenStopLocations <- function (triprow) {
    # Make this work with dataframes and matricies (what apply(dataframe, 1) gives if more than one row)
    if (!is.null(dim(triprow))) {
      return(apply(triprow, 1, getStandardDeviationOfDistanceBetweenStopLocations))
    }
    # At this point we have a vector of field names (this is what apply(dataframe, 1) gives if only one row)
    tripstopindexes <- stops$index[which(triprow['startindex'] <= stops$index & stops$index <= triprow['endindex'])];
    # include first point in trip if not already accounted for
    if (length(tripstopindexes) == 0 || head(tripstopindexes, 1) != triprow['startindex']) {
      tripstopindexes <- c(triprow['startindex'], tripstopindexes)
    }
    # include last point in trip if not already accoutned for
    if (length(tripstopindexes) == 0 || tail(tripstopindexes, 1) != triprow['endindex']) {
      tripstopindexes <- c(tripstopindexes, triprow['endindex'])
    }
    # Define that this function returns NA if there is only one point or two; 
    # it would also return NA if there are only two points because of sd(), 
    # so let's save time and not compute the distance in that case
    if (length(tripstopindexes) <= 2) return(NA)
    deltafeet <- getDeltaDistanceMetersBetweenAdjacent(data$long[tripstopindexes], data$lat[tripstopindexes]) * 3.28084
    # deltafeet will be one element shorter than tripstopindexes
    return(sd(deltafeet))
  }
  
  getDwellTime <- function (triprow) {
    # Make this work with dataframes and matricies (what apply(dataframe, 1) gives if more than one row)
    if (!is.null(dim(triprow))) {
      return(apply(triprow, 1, getDwellTime))
    }
    # At this point we have a vector of field names (this is what apply(dataframe, 1) gives if only one row)
    startindex <- triprow['startindex']
    endindex <- triprow['endindex']
    if (startindex == endindex || endindex == startindex + 1) return(0)
    
    # NOTE: stopped time is "a certain threshold" in paper, using 5 MPH because that is the GeoStats standard
    startdwell <- c(data[startindex,'speedmph'] <=5, 
                    data[startindex:(endindex-1),'speedmph'] > 5 
                    & data[(startindex + 1):endindex,'speedmph'] <= 5)
    enddwell <- data[startindex:(endindex-1),'speedmph'] <= 5 & data[(startindex+1):endindex,'speedmph'] > 5
    startdwellindexes <- which(startdwell) + (startindex - 1)
    enddwellindexes <- which(enddwell) + (startindex - 1)
    if ((length(startdwellindexes) > 0 && length(enddwellindexes) == 0) || 
          (length(startdwellindexes) > 0 && length(enddwellindexes) > 0 && 
           tail(startdwellindexes,1) > tail(enddwellindexes,1))) {
      enddwellindexes <- c(enddwellindexes, endindex)
    }
    if (length(enddwellindexes) == 0 || length(startdwellindexes) == 0) return(0)
    dwelltimes <- as.double(data$datetimeutc[enddwellindexes] - data$datetimeutc[startdwellindexes], "secs")
    return(mean(dwelltimes))
  }
  
  # Neural network all GPS points (page 6)
  #. Average Speed
  #. Maximum Speed
  #. Estimated Horizontal Accuracy Uncertainty
  #. Percent Cell-ID Fixes
  #. Standard Deviation of Distances Between Stop Locations
  #. Average Dwell Time
  
  segments$avgspeedmph <- getAggregateColumn(mean, 'speedmph', data, segments)
  segments$maxspeedmph <- getAggregateColumn(max, 'speedmph', data, segments)
  # NOTE: Estimated horizontal accuracy, paper does not specify aggregate so average is assumed
  # NOTE: Using average HDOP as estimated horizontal accuracy
  # NOTE: No HDOP in ARC
  # segments$avghdop <- getAggregateColumn(mean, 'hdop', data, segments)
  # NOTE: Percent Cell-ID fixes is the percent of time fix was found using cellular data as a fallback when GPS failed
  # NOTE: For our data all points were captured by GPS so this doesn't apply
  
  # NOTE: Critical points are not used in this study
  
  # NOTE: paper does not specify how to determine stops within a trip
  # NOTE: Since this is used to track bus stops, 20s is used
  stops <- data.frame(index=which(data$deltaseconds >= 20))
  
  segments$sddistancelocationsfeet <- apply(segments, 1, getStandardDeviationOfDistanceBetweenStopLocations)
  segments$dwelltimeseconds <- apply(segments, 1, getDwellTime)
  
  # move travmode to end
  travmodeindex <- grep("travmode", names(segments))
  tripsexport <- segments[,c((1:ncol(segments))[-travmodeindex], travmodeindex)]
  # We use "" instead of NA so that WEKA can cope with it
  write.table(tripsexport,file=outputFilename,sep=",",row.names=F, quote=FALSE, na="")
}

travelModeIdentification_Gonzalez_createTrainingFile <- function() {
  pointsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/train180points.csv"
  segmentsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearGeneralTrainingData/train180.csv"  
  outputFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/GonzalezTrainingData/ForWekaTrain180.csv"
  travelModeIdentification_Gonzalez(segmentsFilename, pointsFilename, outputFilename)
}

travelModeIdentification_Gonzalez_createTestingFile <- function() {
  pointsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearReferenceData/test90points.csv"
  segmentsFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/ArcWearReferenceData/test90.csv"
  outputFilename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/GonzalezTrainingData/ForWekaTest90.csv"
  #filename <- "//drake/NCHRP-08-89-GPS/Workspace/Task3/GonzalezFilesForWeka/4000223_P1weka.csv"
  travelModeIdentification_Gonzalez(segmentsFilename, pointsFilename, outputFilename)
}