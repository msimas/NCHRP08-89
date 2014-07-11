# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# 1. Filter GPS data based on the assigned travel date
# (the surveyor can re-confirm this date in TripBuilder).
# 2. Create first place of the day so that the display can be place-based, the arrival time of this
# place was pre-set to 3:00am and its departure time was set to the start time of the first
# identified GPS trip; the coordinates for this place were also set based on the first identified
# trip's origin.
# 3. Project GPS points to the local coordinate system (Israel National Grid, EPSG:2039).
# 4. Split GPS points into trips leading to places based on a 120 seconds dwell time criteria.
# 5. Look for mode transitions within each detected trip (non-motorized to motorized and viceversa)
# and further split trips based on them.
# 6. Determine if each identified trip can be attributed to real movement or GPS noise.
# 7. Check trips against minimum travel time and distance constraints (distance covered >= 100 m
# and travel time >= 1 minute), if it failed to meet them its points were aggregated onto the next
# trip.

modeTransitionIdentification_Oliveira <- function(data) {
  
  # 1. Filter GPS data based on the assigned travel date
  # NOTE: Not filtering based on travel date because travel dates are unknown
  # 2. Create first place of day
  # NOTE: Not necessary we're making trips, not places
  # 3. Project GPS points
  # NOTE: Not projecting points because the projections are unknown for the various data sources
  # 4. Split GPS points into trips based on 120 seconds dwell time
  source("Trip Identification/Wolf.r")
  trips <- tripIdentification_Wolf(data)
  
  # 5. Look for mode transitions within each detected trip (non-motorized to motorized and viceversa)
  # and further split trips based on them.
  # Returns indexes of points within the trip, not within the data stream (add startindex-1 to get points within the datastream)
  
  getModeTransitionIndexes <- function(triprow) {
    # Make this work with dataframes and matricies (what apply(dataframe, 1) gives if more than one row)
    if (!is.null(dim(triprow))) {
      return(getModeTransitionIndexes(as.matrix(triprow)[1,]))
    }
    # At this point we have a vector of field names (this is what apply(dataframe, 1) gives if only one row)
    startIndex <- triprow['startindex']
    endIndex <- triprow['endindex']
    tripPoints <- data[startIndex:endIndex,]
    if (length(tripPoints) < 10) return(NULL)
    searchWindow <- 10
    avgSpeedMpsThreshold <- 16
    sdSpeedMpsThreshold <- 2.25
    #windows <- data.frame(centeredon=(9+startIndex):endIndex, 
    #                      startindex=startIndex:(endIndex-9), 
    #                      endindex=(9+startIndex):endindex)
    ## Notice that windows is 10 elements shorter than the point data for this trip
    #windows$avgspeedmps <- getAggregateColumn(mean, 'speedmps', data, windows)
    #windows$sdspeedmps <- getAggregateColumn(sd, 'speedmps', data, windows)
    #windows$ismotorized <- windows$avgspeedmps > 16
    ## motorized changed from previous record to this one, and standard dev of speed is > 2.25
    #windows$ismodetransition <- windows$sdspeedmps > 2.25 & 
    #                            c(FALSE, # First record can't be a transition because there is nothing to transition from 
    #                              head(windows$ismotorized, -1) != tail(windows$ismotorized, -1))
    #modetransitionindexes <- which(windows$ismodetransition)
    
    # This is a direct port of the original C#, little effort has be made to make it more R-ish (functional paradigm, etc.)
    lastTime <- tripPoints$datetimeutc[1]
    lastSpeed <- tripPoints$speedmps[1]
    lastTransition <- lastTime - 30 # 30 seconds ago
    lastTransitionPointIndex <- 0
    minDistanceMeters <- 100
    minDurationSeconds <- 120
    endIndexes <- NULL
    # Use first window of points to decide if we are initially WALK or AUTO
    initAvgSpeedMps <- mean(tripPoints$speedmps[1:min(searchWindow, length(tripPoints))])
    # Don't use sdSpeed because we are not looking for a transition, just the initial state
    isMotorized <- initAvgSpeedMps > avgSpeedMpsThreshold
    for(pointIndex in 1:nrow(tripPoints)) {
      pointSpeed <- tripPoints$speedmps[pointIndex]
      if (pointIndex + 1 > searchWindow) {
        avgSpeedMps <- mean(tripPoints$speedmps[(pointIndex + 1 - searchWindow):pointIndex])
        sdSpeedMps <- sd(tripPoints$speedmps[(pointIndex + 1 - searchWindow):pointIndex])
        if (avgSpeedMps < avgSpeedMpsThreshold && sdSpeedMps < sdSpeedMpsThreshold && isMotorized) {
          # Walk forward from the beginning of the searchWindow to where the transition really happened
          index <- pointIndex + 1 - searchWindow
          while (index < pointIndex && tripPoints$speedmps[index] > avgSpeedMpsThreshold) {

            index <- index + 1
          }
          # endIndexes holds the end points
          # the end point of the previous mode will be index - 1
          if (index > 1) {
            index <- index - 1
          } else {
            stop("Mode end point found on previous trip, casting to first point of this trip.");
          }
          pointTime <- tripPoints$datetimeutc[index]
          secondsFromLastTransition <- as.double(pointTime - lastTransition, "secs");
          metersFromLastTransition = sum(getDeltaDistanceMetersBetweenAdjacent(tripPoints$long[(lastTransitionPointIndex + 1):index], tripPoints$lat[(lastTransitionPointIndex + 1):index]))
          if (metersFromLastTransition >= minDistanceMeters && secondsFromLastTransition >= minDurationSeconds)
          {
            lastTransition <- pointTime;
            lastTransitionPointIndex <- index;
            isMotorized <- FALSE
            endIndexes <- c(endIndexes, index)
          }
        }
        else if (avgSpeedMps > avgSpeedMpsThreshold && sdSpeedMps > sdSpeedMpsThreshold && !isMotorized)
        {
          # Walk forward from the beginning of the searchWindow to where the transition really happened
          index <- pointIndex + 1 - searchWindow;
          while (index < pointIndex && tripPoints$speedmps[index] < avgSpeedMpsThreshold)
          {
            index <- index + 1
          }
          # endIndexes holds the end points
          # the end point of the previous mode will be index - 1
          if (index > 1)
          {
            index <- index - 1
          }
          else
          {
            stop("Mode end point found on previous trip, casting to first point of this trip.")
          }
          
          pointTime <- tripPoints$datetimeutc[index]
          secondsFromLastTransition <- as.double(pointTime - lastTransition, "secs");
          metersFromLastTransition = sum(getDeltaDistanceMetersBetweenAdjacent(tripPoints$long[(lastTransitionPointIndex + 1):index], tripPoints$lat[(lastTransitionPointIndex + 1):index]))
          if (metersFromLastTransition >= minDistanceMeters && secondsFromLastTransition >= minDurationSeconds)
          {
            lastTransition <- pointTime;
            lastTransitionPointIndex <- index;
            isMotorized <- TRUE
            endIndexes <- c(endIndexes, index)
          }
        }
      }
      lastSpeed <- pointSpeed
    }
    return(endIndexes)
  }
  
  getLoggingFrequency <- function(pointTimes) {
    pointIndex <- 2
    totalDeltaSeconds <- 0
    numberOfDeltaSeconds <- 0
    while (pointIndex <= length(pointTimes)) {
      deltaSeconds <- as.double(pointTimes[pointIndex] - pointTimes[pointIndex - 1], "secs")
      if (deltaSeconds < 15) {
        totalDeltaSeconds <- totalDeltaSeconds + deltaSeconds
        numberOfDeltaSeconds <- numberOfDeltaSeconds + 1
      }
      pointIndex <- pointIndex + 1
    }
    return(max(1, round(totalDeltaSeconds / numberOfDeltaSeconds)))
  }
  
  getDifferenceBetweenAngles <- function(angle2, angle1) {
    if (length(angle2) > 1) return(mapply(getDifferenceBetweenAngles, angle2, angle1))
    difference <- angle2 - angle1
    while (difference < -180) difference <- difference + 360
    while (difference > 180) difference <- difference - 360
    return(difference)
  }
  
  data$deltadistancemeters <- c(0, getDeltaDistanceMetersBetweenAdjacent(data$long, data$lat))
  deltaHours <- data$deltaseconds / 3600
  deltaKilometers <- data$deltadistancemeters / 1000
  data$spacespeedkph <- c(0, tail(deltaKilometers, -1) / tail(deltaHours, -1))
  deltaHeading <- c(0, getDifferenceBetweenAngles(data$heading[2:nrow(data)], data$heading[1:(nrow(data)-1)]))
  data$headingspeeddegreesps <- c(0, tail(deltaHeading, -1) / tail(data$deltaseconds, -1))
  # returns a vector of headingJumps, spaceJumps
  countJumps <- function(tripPoints)
  {
    numberHeadingJumps <- 0
    numberOfSpaceJumps <- 0
    delayTimeMinutes <- 0.167
    nbPoints <- dim(tripPoints)[1]
    if (nbPoints > 0) {
      for (pointIndex in 1:nbPoints) {
        if (!is.na(tripPoints$headingspeeddegreesps[pointIndex]) && 
              abs(tripPoints$headingspeeddegreesps[pointIndex]) > 60) {
          numberHeadingJumps <- numberHeadingJumps + 1
        }
        if (!is.na(tripPoints$spacespeedkph[pointIndex]) && !is.na(tripPoints$speedkph[pointIndex]) && 
              tripPoints$speedkph[pointIndex] > 0 && 
              abs(tripPoints$spacespeedkph[pointIndex] - tripPoints$speedkph[pointIndex]) / tripPoints$speedkph[pointIndex] > 4.0) {
          numberOfSpaceJumps <- numberOfSpaceJumps + 1
        }
      }
    }
    return(c(nbHeadingJumps=numberHeadingJumps, nbSpaceJumps=numberOfSpaceJumps))
  }
  
  isPhantom <- function (startIndex, endIndex, distanceMeters, travelTimeSeconds) {
    logFreq <- getLoggingFrequency(data$datetimeutc[startIndex:endIndex])
    expectedPointCount <- travelTimeSeconds / logFreq * 0.95
    straightDistanceMeters <- getDeltaDistanceMeters(data$long[startIndex], data$lat[startIndex], data$long[endIndex], data$lat[endIndex])
    circuity <- distanceMeters / straightDistanceMeters
    avgspeedkph <- mean(data$speedkph[startIndex:endIndex])
    jumps <- countJumps(data[startIndex:endIndex, ])
    headingJumpFreq <- jumps[1] / (travelTimeSeconds / 60)
    spaceJumpFreq <- jumps[2] / (travelTimeSeconds / 60)
    return ((circuity > 10) ||
      (avgspeedkph < 1) || (avgspeedkph > 120) || 
      # These lines are commented out in reference implementation
      #(logFreq < 5 && newTrip.TripPoints.Count > expectedPointCount && newTrip.AvgSpeed > 10 && newTrip.AvgSpeed > newTrip.PointsAvgSpeed * 1.5) ||
      #(newTrip.AvgSpeed > 10 && newTrip.HeadingJumpFreq > 2 && newTrip.SpaceJumpFreq > 2 && circuity > 10) ||
      (spaceJumpFreq > 2 || headingJumpFreq > 6)
    )
  }
  
  getAllModeTransitionIndexes <- function (trips) {
    allEndIndexes <- NULL
    for (i in 1:nrow(trips)) {
      endIndexes <- trips$startindex[i] - 1 + unlist(as.list(getModeTransitionIndexes(trips[i,])))
      #if (is.null(allEndIndexes) || tail(allEndIndexes, 1) != trips$startindex[i]) allEndIndexes <- c(allEndIndexes, trips$startindex[i])
      if (length(endIndexes) > 0) {
        if (tail(endIndexes, 1) != trips$endindex[i]) endIndexes <- c(endIndexes, trips$endindex[i])
        allEndIndexes <- c(allEndIndexes, endIndexes)
      }
      if (is.null(allEndIndexes) || tail(allEndIndexes, 1) != trips$endindex[i]) allEndIndexes <- c(allEndIndexes, trips$endindex[i])
    }
    
    # Vet allEndIndexes for trips that fail distance or time (step #7)
    # allEndIndexes does not include 1
    filteredEndIndexes <- NULL
    startIndex <- 1
    # Using a for loop here because if the endIndex fails it should be absorbed by the next endIndex
    for (j in 1:length(allEndIndexes)) {
      endIndex <- allEndIndexes[j]  
      # 7. Check trips against minimum travel time and distance constraints (distance covered >= 100 m
      # and travel time >= 1 minute), if it failed to meet them its points were aggregated onto the next
      # trip.
      minTripDistanceMeters <- 100
      minTravelTimeSeconds <- 60
      distance <- sum(getDeltaDistanceMetersBetweenAdjacent(data$long[startIndex:endIndex], data$lat[startIndex:endIndex]))
      travelTime <- as.double(data$datetimeutc[endIndex] - data$datetimeutc[startIndex], "secs")
      if (distance >= minTripDistanceMeters && travelTime >= minTravelTimeSeconds) {
        if (!isPhantom(startIndex, endIndex, distance, travelTime)) {
          filteredEndIndexes <- c(filteredEndIndexes, endIndex)
          startIndex <- endIndex + 1
        }
      }
    }
    return(filteredEndIndexes)
  }
  
  data$speedkph <- data$speedmph * 1.60934
  endIndexes <- getAllModeTransitionIndexes(trips)
  trips2 <- data.frame(startindex=c(1, head(endIndexes,-1) + 1), endindex=endIndexes)
  
  # 6. Determine if each identified trip can be attributed to real movement or GPS noise.
  # Compute avg, max, and sd speed.
  trips2$avgpointspeedkph <- getAggregateColumn(mean, 'speedkph', data, trips2)
  trips2$sdpointspeedkph <- getAggregateColumn(sd, 'speedkph', data, trips2)
  # Estimate 95th percentile speed
  # NOTE: Paper says multiplying the segment's average by the 1.96 times the point speed standard deviation
  # NOTE: but reference source code adds the average to 1.96*sdspeed; addition is mathematically correct anyway
  trips2$percentile95speedkph <- trips2$avgpointspeedkph + (1.96 * trips2$sdpointspeedkph)
  
  # precomputed values
  modenames <- c("walk", "motorized")
  avgspeedkphs <- c(3, 30)
  sdspeedkphs <- c(2, 30)
  maxspeedkphs <- c(15, 150)
  
  modes <- data.frame(
    name=modenames,
    avgspeedkph=avgspeedkphs,
    sdspeedkph=sdspeedkphs,
    maxspeedkph=maxspeedkphs
  )
  
  # Depends on modes dataframe being already created
  chooseMode <- function (avgspeedkph, sdspeedkph, percentile95speedkph) {
    assignedMode <- NA
    speedDiff <- 999999
    ratioSd <- 999999
    for (i in 1:nrow(modes)) {
      moderow <- modes[i,]
      nbSd <- abs(avgspeedkph - moderow[['avgspeedkph']]) / moderow[['sdspeedkph']];
      sdRatio <- abs(moderow[['sdspeedkph']] - sdspeedkph);
      if (nbSd < 1.96 && percentile95speedkph <= moderow[['maxspeedkph']] && sdRatio < ratioSd && nbSd < speedDiff) {
        speedDiff <- nbSd;
        ratioSd <- sdRatio;
        assignedMode <- moderow['name'];
      }
    }
    return(assignedMode)
  }
  
  for (i in 1:dim(trips2)[1])
  {
    trips2[i,'mode'] <- as.vector(chooseMode(trips2$avgpointspeedkph[i], trips2$sdpointspeedkph[i], trips2$percentile95speedkph[i])[[1]])
  }

  mergeTrips <- function(tripIndex1, tripIndex2, trips2) {
    if (!(tripIndex1 > 0 && tripIndex1 <= nrow(trips2) &&
          tripIndex2 > 0 && tripIndex2 <= nrow(trips2) &&
          abs(tripIndex1 - tripIndex2) == 1)) {
      return (trips2)
    } else {
      prevTripIndex <- min(tripIndex1, tripIndex2)
      currTripIndex <- max(tripIndex1, tripIndex2)

      trips2$endindex[prevTripIndex] <- trips2$endindex[currTripIndex]
      trips2$endtime[prevTripIndex] <- trips2$endtime[currTripIndex]
      trips2$endlat[prevTripIndex] <- trips2$endlat[currTripIndex]
      trips2$endlong[prevTripIndex] <- trips2$endlong[currTripIndex]
      
      trips2$travtimeminutes[prevTripIndex] <- round(difftime(trips2$endtime[prevTripIndex], trips2$starttime[prevTripIndex], units="mins"), digits = 2)
      trips2$distancemeters[prevTripIndex] <- round(sum(getDeltaDistanceMetersBetweenAdjacent(data$long[trips2$startindex[prevTripIndex]:trips2$endindex[prevTripIndex]], 
                                                                                              data$lat[trips2$startindex[prevTripIndex]:trips2$endindex[prevTripIndex]])
                                                        ), 
                                                    digits = 0);
      
      trips2$avgpointspeedkph[prevTripIndex] <- getAggregateColumn(mean, 'speedkph', data, trips2[prevTripIndex,])
      trips2$sdpointspeedkph[prevTripIndex] <- getAggregateColumn(sd, 'speedkph', data, trips2[prevTripIndex,])
      trips2$percentile95speedkph[prevTripIndex] <- trips2$avgpointspeedkph[prevTripIndex] + (1.96 * trips2$sdpointspeedkph[prevTripIndex])
      
      trips2$avgspeedkph[prevTripIndex] <- round((trips2$distancemeters[prevTripIndex] / 1000) / as.numeric(trips2$travtimeminutes[prevTripIndex] / 60), digits = 2)
          
      # remove second trip
      trips2 <- trips2[-currTripIndex, ]
      return (trips2)
    }
  }
  
  collapseSameMode <- function(trips2) {
    tripIndex <- 2
    while (tripIndex <= nrow(trips2)) {
      currMode <- trips2$mode[tripIndex]
      prevMode <- trips2$mode[tripIndex - 1]
      activityDuration <- round(difftime(trips2$starttime[tripIndex], 
                                         trips2$endtime[tripIndex - 1], units="mins"), 
                                digits = 2)
      minPlaceStopMinutes <- 2
      if (activityDuration < minPlaceStopMinutes && !is.na(currMode) && !is.na(prevMode) && currMode == prevMode) {
        newTrips2 <- mergeTrips(tripIndex - 1, tripIndex, trips2)
        if (nrow(newTrips2) < nrow(trips2)) {
          trips2 <- newTrips2
          tripIndex <- tripIndex - 1
        }
      }
      tripIndex <- tripIndex + 1
    }
    return (trips2)
  }
  
  # Remove non-motorized trips (segments) surrounded by motorized trips (segments) within the same trip (origin-destination)
  collapseIntraTripNonMotorized <- function(trips2) {
    if (nrow(trips2) < 3) return (trips2)
    tripIndex <- 3
    while (tripIndex <= nrow(trips2)) {
      if (!is.na(trips2$mode[tripIndex - 2]) && trips2$mode[tripIndex - 2] == 'motorized' && 
          !is.na(trips2$mode[tripIndex - 1]) && !trips2$mode[tripIndex - 1] == 'motorized' &&
          !is.na(trips2$mode[tripIndex]) && trips2$mode[tripIndex] == 'motorized') {
        newTrips2 <- mergeTrips(tripIndex - 2, tripIndex - 1, trips2)
        if (nrow(newTrips2) < nrow(trips2)) {
          trips2 <- newTrips2
          tripIndex <- tripIndex - 1
          newTrips2 <- mergeTrips(tripIndex - 1, tripIndex, trips2)
          if (nrow(newTrips2) < nrow(trips2)) {
            trips2 <- newTrips2
            tripIndex <- tripIndex - 1
          }
        }
      }
      tripIndex <- tripIndex + 1
    }
    return(trips2)
  }

  trips2$starttime <- data[trips2$startindex, 'datetimeutc']
  trips2$endtime <- data[trips2$endindex, 'datetimeutc']
  trips2$startlat <- data[trips2$startindex, 'lat']
  trips2$startlong <- data[trips2$startindex, 'long']
  trips2$endlat <- data[trips2$endindex, 'lat']
  trips2$endlong <- data[trips2$endindex, 'long']
  
  trips2$distancemeters <- NA
  trips2$travtimeminutes <- round(difftime(trips2$endtime, trips2$starttime, units="mins"), digits = 2)
  for (index in 1:nrow(trips2)) {
    trips2[index, 'distancemeters'] <- round(sum(getDeltaDistanceMetersBetweenAdjacent(data[trips2[index,'startindex']:trips2[index,'endindex'], 'long'], data[trips2[index,'startindex']:trips2[index,'endindex'], 'lat'])), digits = 0);
  }
  trips2$avgspeedkph <- round((trips2$distancemeters / 1000) / as.numeric(trips2$travtimeminutes / 60), digits = 2)
 
  trips2 <- collapseIntraTripNonMotorized(trips2)
  trips2 <- collapseSameMode(trips2)
  
  trips2$gpstripid <- 1:nrow(trips2)
  
  return(trips2)
}