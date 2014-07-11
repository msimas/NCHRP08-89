# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

#calculate point densities
getPointDensities_old <- function(data, indexBound, radiusMeters) {
  len <- nrow(data)
  for(i in 1:len) {
    density <- 0
    for(j in (i - indexBound):(i + indexBound)) {
      if(j > 0 && j <= len) {
        deltaMeters <- getDeltaDistanceMeters(
          data[i, 'long'],
          data[i, 'lat'],
          data[j, 'long'],
          data[j, 'lat']
        )
        
        if(deltaMeters < radiusMeters) density <- density + 1
      }
    }
    data[i, 'pointDensity'] <- density
  }
  return(data$pointDensity)
}

getPointDensities_vectorResult <- function(data, indexBound, radiusMeters) {
  len <- nrow(data)
  result <- vector(mode="numeric", length=len)
  for(i in 1:len) {
    density <- 0
    for(j in (i - indexBound):(i + indexBound)) {
      if(j > 0 && j <= len) {
        deltaMeters <- getDeltaDistanceMeters(
          data[i, 'long'],
          data[i, 'lat'],
          data[j, 'long'],
          data[j, 'lat']
        )
        
        if(deltaMeters < radiusMeters) density <- density + 1
      }
    }
    result[i] <- density
  }
  return(result)
}

getSquaredDistance <- function(x1, y1, x2, y2) {
  return((x1-x2)^2 + (y1-y2)^2)
}

getPointDensities_sq <- function(data, indexBound, radiusMeters) {
  len <- nrow(data)
  result <- vector(mode="numeric", length=len)
  radiusFeet <- radiusMeters * 3.28084
  radiusFeetSquared <- radiusFeet^2
  for(i in 1:len) {
    density <- 0
    for(j in (i - indexBound):(i + indexBound)) {
      if(j > 0 && j <= len) {
        # because the data is projected, euclidean distance can be used (faster than great circle)
        deltaFeetSquared <- getSquaredDistance(
          data[i, 'projectedx'],
          data[i, 'projectedy'],
          data[j, 'projectedx'],
          data[j, 'projectedy']
        )
        
        # compare squares because square root is relatively expensive
        if(deltaFeetSquared < radiusFeetSquared) density <- density + 1
      }
    }
    result[i] <- density
  }
  return(result)
}

getPointDensities_forward <- function(data, indexBound, radiusMeters) {
  len <- nrow(data)
  result <- rep(0, len)
  radiusFeet <- radiusMeters * 3.28084
  radiusFeetSquared <- radiusFeet^2
  for(i in 1:len) {
    # only look forward, because the results of the backwards looking will be done 
    # by accumulating in the second point on the way forward
    for(j in (i + 1):(i + indexBound)) {
      if(j > 0 && j <= len) {
        # because the data is projected, euclidean distance can be used (faster than great circle)
        deltaFeetSquared <- getSquaredDistance(
          data[i, 'projectedx'],
          data[i, 'projectedy'],
          data[j, 'projectedx'],
          data[j, 'projectedy']
        )
        
        # compare squares because square root is relatively expensive
        if(deltaFeetSquared < radiusFeetSquared) {
          result[i] <- result[i] + 1
          # this comparison also accumulates towards the other point's density
          result[j] <- result[j] + 1
        }
      }
    }
  }
  return(result)
}

getPointDensities_DollarIndex <- function(data, indexBound, radiusMeters) {
  projectedx <- data$projectedx
  projectedy <- data$projectedy
  len <- length(projectedx)
  result <- rep(0, len)
  radiusFeet <- radiusMeters * 3.28084
  radiusFeetSquared <- radiusFeet^2
  for(i in 1:len) {
    # only look forward, because the results of the backwards looking will be done 
    # by accumulating in the second point on the way forward
    for(j in (i + 1):(i + indexBound)) {
      if(j > 0 && j <= len) {
        # because the data is projected, euclidean distance can be used (faster than great circle)
        deltaFeetSquared <- getSquaredDistance(
          projectedx[i],
          projectedy[i],
          projectedx[j],
          projectedy[j]
        )
        # compare squares because square root is relatively expensive
        if(deltaFeetSquared < radiusFeetSquared) {
          result[i] <- result[i] + 1
          # this comparison also accumulates towards the other point's density
          result[j] <- result[j] + 1
        }
      }
    }
  }
  return(result)
}

getPointDensities_SplitGreatCircle <- function(data, indexBound, radiusMeters) {
  dlong <- data$long
  dlat <- data$lat
  len <- length(dlong)
  result <- vector(mode="numeric", length=len)
  for(i in 1:len) {
    density <- 0
    for(j in (i - indexBound):(i + indexBound)) {
      if(j > 0 && j <= len) {
        deltaMeters <- getDeltaDistanceMeters(
          dlong[i],
          dlat[i],
          dlong[i],
          dlat[i]
        )
        
        if(deltaMeters < radiusMeters) density <- density + 1
      }
    }
    result[i] <- density
  }
  return(result)
}

tripIdentification_Schuessler_Axhausen_Config <- function(data, getPointDensitiesMethod) {
  # constants
  dwellTime <- 900
  indexBound <- 30
  radiusMeters <- 15
  len <- nrow(data)
  densityThreshold <- 15
  speedThreshold <- .01
  
  # variables
  pointsSincePointDensityGreaterThan15 <- 0
  timeSincePointDensityGreaterThan15 <- 0
  timeSinceSpeedBelowSpeedThreshold <- 0
  tripNum <- 1
  activityNum <- 1
  
  data$pointDensity <- getPointDensitiesMethod(data, indexBound, radiusMeters)
  
  data$activityNum <- NA
  
  i <- 1
  while(i <= len) {
    # mark points with high dwell times as activities
    if(data[i, 'deltaseconds'] > dwellTime) {
      data[i, 'activityNum'] <- activityNum
      activityNum <- activityNum + 1
      i <- i + 1
      next
    }
    
    # this point has a low dwell time
    if(data[i, 'pointDensity'] > densityThreshold) {
      pointsSincePointDensityGreaterThan15 <- pointsSincePointDensityGreaterThan15 + 1
      timeSincePointDensityGreaterThan15 <- timeSincePointDensityGreaterThan15 + data[i, 'deltaseconds']
    } else {
      pointsSincePointDensityGreaterThan15 <- 0
      timeSincePointDensityGreaterThan15 <- 0
    }
    
    if(data[i, 'speedmps'] < speedThreshold) {
      timeSinceSpeedBelowSpeedThreshold < timeSinceSpeedBelowSpeedThreshold + 1
    } else {
      timeSinceSpeedBelowSpeedThreshold <- 0
    }
      
    # find activities
    if(pointsSincePointDensityGreaterThan15 > 10 || 
         timeSincePointDensityGreaterThan15 > 300 ||
         timeSinceSpeedBelowSpeedThreshold > 120) {
      # activity detected - rewind to find beginning of activity
      pointsSincePointDensityLessThan15 <- 0
      while(i > 0) {
        if(data[i, 'pointDensity'] > densityThreshold) {
          pointsSincePointDensityLessThan15 <- 0
        } else {
          pointsSincePointDensityLessThan15 <- pointsSincePointDensityLessThan15 + 1
        }
        
        if(pointsSincePointDensityLessThan15 >= 15) {
          break
        }
        
        i <- i - 1  
      }
      i <- i + 1
      
      # now fast forward to actual start point
      while(i <= len) {
        if(data[i, 'pointDensity'] > densityThreshold) break
        i <- i + 1
      }
      
      # set activity num for points
      pointsSincePointDensityLessThan15 <- 0
      while(i <= len) {
        if(data[i, 'pointDensity'] > densityThreshold) {
          pointsSincePointDensityLessThan15 <- 0
        } else {
          pointsSincePointDensityLessThan15 <- pointsSincePointDensityLessThan15 + 1
        }
        data[i, 'activityNum'] <- activityNum
        
        # end of activity found
        if(pointsSincePointDensityLessThan15 >= 15) {
          # unset points that are not part of the activity
          data[i:(i - pointsSincePointDensityLessThan15 + 1), 'activityNum'] <- NA
          i <- i - pointsSincePointDensityLessThan15 + 1
          break
        }
  
        i <- i + 1
      }
      activityNum <- activityNum + 1
    }
    i <- i + 1
  }
  
  data$tripNum <- NA
  
  # find point with no activity (start)
  i <- 1
  while(i <= len) {
    if(is.na(data[i, 'activityNum'])) {
      startIndex <- i
      endIndex <- NA
      
      # find point with activity (end)
      while(i <= len) {
        if(!is.na(data[i, 'activityNum'])) {
          endIndex <- i - 1
          break
        }
        i <- i + 1
      }
      if (is.na(endIndex)) {
        # reached end of while loop (i.e. not exited via break)
        endIndex <- len
      }
      
      # calculate sequence density
      densityRatio <- nrow(subset(data[startIndex:endIndex, ], pointDensity >= 15)) / (endIndex - startIndex + 1)
      
      if(densityRatio > 2/3) {
        # sequence is activity - increment all activityNums and insert new activity
        newActivityNum <- 1
        if (startIndex > 1) {
          newActivityNum <- data[startIndex - 1, 'activityNum'] + 1
        }
        data[startIndex:endIndex, 'activityNum'] <- newActivityNum
        data[endIndex:len, 'activityNum'] <- data[endIndex:len, 'activityNum'] + 1
      } else {
        # mark points as trip
        data[startIndex:endIndex, 'tripNum'] <- tripNum
        tripNum <- tripNum + 1
      }
    }
    i <- i + 1
  }
  
  trips <- NA
  # more than one trip
  if(tripNum > 2) {
    tripNums <- 1:(tripNum-1)
    tripNumList <- sapply(tripNums, function (x) which(data$tripNum == x))
    startIndices <- sapply(tripNumList, min)
    endIndices <- sapply(tripNumList, max)
    trips <- data.frame(
      gpstripid = tripNums,
      startindex = startIndices,
      endindex = endIndices
    )
  } else {
    trips <- data.frame(gpstripid = 1, startindex = 1, endindex = nrow(data))
  }
  
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

tripIdentification_Schuessler_Axhausen <- function(data) {
  return(tripIdentification_Schuessler_Axhausen_Config(data, getPointDensities_DollarIndex))
}