# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

modeTransitionIdentification_TsuiShalaby_SchuesslerAxhausen <- function(data) {
  # Split GPS points into trips based on 120 seconds dwell time
  source("Trip Identification/Wolf.r")
  trips <- tripIdentification_Wolf(data)
  segments <- NULL
  for (i in 1:nrow(trips)) {
    tripData <- data[trips$startindex[i]:trips$endindex[i],]
    tripSegments <- modeTransitionIdentification_TsuiShalaby_SchuesslerAxhausen_perTrip(tripData)
    tripSegments$gpstripid <- trips$gpstripid[i]
    if (is.null(segments)) {
      segments <- tripSegments
    } else {
      # The mode transition identification will give indexes from 1 to N per trip. 
      # Add the startindex of each trip (and - 1) to make them indexes within the trip
      tripSegments$startindex <- tripSegments$startindex + (trips$startindex[i] - 1)
      tripSegments$endindex <- tripSegments$endindex + (trips$startindex[i] - 1)
      segments <- merge(segments, tripSegments, all=TRUE)
    }
  } 
  return (segments)
}

modeTransitionIdentification_TsuiShalaby_SchuesslerAxhausen_perTrip <- function(tripData) {
  nrowdata <- nrow(tripData)
  
  # tail of -1 is all but first record, head of -1 is all but last record
  tripData$eowstep1 <- c(0, tail(tripData$speedmps, -1) > 2.78 & head(tripData$speedmps, -1) < 2.78)
  tripData$sowstep1 <- c(0, tail(tripData$speedmps, -1) < 2.78 & head(tripData$speedmps, -1) > 2.78)
  tripData$eog <- tripData$deltaseconds >= 80
  tripData$modeendpoint <- rep(NA, nrowdata)
  tripData$modesegmentid <- rep(NA, nrowdata)
  
  # Given a eowstep1 point, find earliest point with speed above 2.78 m/s 
  # or at least 3 consecutive GPS points with a maximum acceleration of 0.1 m/s2
  # - the latest of these 3 points with small acceration is a potential EOW point
  # (Bottom of page 11)
  # Returns the index of the potential EOW point, or -1 if it was not found
  findEowHelper <- function(dataFrame, eowstep1Index) {
    consecutiveAccel <- 0
    for (i in max(eowstep1Index - 1, 1):1) {
      if (dataFrame$speedmps[i] > 2.78) break
      if (dataFrame$accelmps2[i] <= 0.1) {
        consecutiveAccel <- consecutiveAccel + 1
      }
      else {
        consecutiveAccel <- 0
      }
      if (consecutiveAccel == 3) {
        return(i + 2)
      }
    }
    return(-1)
  }
  
  # For each eowstep1 point, find the potential EOW point
  getEow <- function(dataFrame) {
    result <- rep(0, nrow(dataFrame))
    for (i in 1:nrowdata) {
      if (dataFrame$eowstep1[i] == 1) {
        eow = findEowHelper(dataFrame, i)
        if (eow > -1) {
          result[eow] <- i;
        }
      }
    }
    return(result)
  }
  
  # Reverse of EOW
  findSowHelper <- function(dataFrame, sowstep1Index) {
    consecutiveAccel <- 0
    for (i in min((sowstep1Index + 1), nrowdata):nrowdata) {
      if (dataFrame$speedmps[i] > 2.78) break
      if (dataFrame$accelmps2[i] <= 0.1 ) {
        consecutiveAccel <- consecutiveAccel + 1
      }
      else {
        consecutiveAccel <- 0
      }
      if (consecutiveAccel == 3) {
        return(i - 2)
      }
    }
    return(-1)
  }
  
  getSow = function(dataFrame) {
    result <- rep(0, nrow(dataFrame))
    for (i in nrowdata:1) {
      if (dataFrame$sowstep1[i] == 1) {
        sow = findSowHelper(dataFrame, i)
        if (sow > -1) {
          result[sow] <- i;
        }
      }
    }
    return(result)
  }
  
  # an EOW point can be followed by an SOW or an EOG point but not by an EOW point
  # an SOW point can be followed by an EOW or an EOG point but not by an SOW point
  # an EOG point can either be an EOW or an SOW point
  # the speed of the stage between an SOW and an EOW point has always to be smaller than
  # 2.78 m/s and the time difference has to be at least 60 s
  # time difference between and EOW and an SOW point has to be at least 120 s
  # (Page 12)
  # NOTE: No guidance on whether to throw out a SOW if another SOW is detected before an EOW or EOG.
  # NOTE: No guidance on whether to throw out a SOW if an EOG fails to be an EOW but could be another SOW.
  # NOTE: This implementation keeps the first SOW (notice that none of the rules have a maximum time difference).
  getModeEndPoints <- function(dataFrame) {
    result <- rep(0, nrow(dataFrame))
    sowIndex = 0
    eowIndex = 0
    for (i in 1:nrowdata) {
      if ((!is.na(dataFrame$sow[i]) && dataFrame$sow[i])
          # Use EOG only if SOW isn't set (as in, we are looking for a SOW Here)
          || (dataFrame$eog[i] && sowIndex == 0)) {
        if (eowIndex != 0 && sowIndex == 0) {
          # Trying to find the next SOW after an EOW
          if (evaluateEowToSow(dataFrame, eowIndex, i)) {
            # This SOW is good
            sowIndex = i
            eowIndex = 0
          }
        } else {
          # first SOW
          sowIndex = i
        }
      }
      if ((!is.na(dataFrame$eow[i]) && dataFrame$eow[i])
          # Use EOG only if EOW isn't set (as in, we are looking for an EOW Here)
          || (dataFrame$eog[i] && eowIndex == 0)) {
        eowIndex = i
      }
      if (sowIndex != 0 && eowIndex != 0) {
        if (evaluateSowToEow(dataFrame, sowIndex, eowIndex)) {
          result[sowIndex] <- "SOW"
          result[eowIndex] <- "EOW"
          sowIndex = 0
        } else {
          # Bad EOW
          eowIndex = 0
        }
      }
    }
    return(result)
  }
  
  getModeSegmentIDs <- function(dataFrame) {
    result <- rep(0, nrow(dataFrame))
    modeSegmentID = 1
    for (i in 1:nrowdata) {
      if (!is.na(dataFrame$modeendpoint[i]) && 
            dataFrame$modeendpoint[i] == "SOW") {
        modeSegmentID <- modeSegmentID + 1
      }
      # Note that End of Walk doesn't increment the mode segment id until the next point
      if (i > 1 && !is.na(dataFrame$modeendpoint[i - 1]) && 
            dataFrame$modeendpoint[i - 1] == "EOW") {
        modeSegmentID <- modeSegmentID + 1
      }
      result[i] <- modeSegmentID
    }
    return(result)
  }
  
  getIndexesAtCutPoints <- function(originalData, cutPoints) {
    if (length(cutPoints) == 0) return (1:length(originalData))
    toReturn <- c(list(originalData[1]:(originalData[cutPoints[1]-1])), 
                  lapply(cutPoints, 
                         FUN = function(value) 
                           if(is.na(cutPoints[which(cutPoints == value) + 1])) { 
                             originalData[value]:tail(test, 1)
                           } else { 
                             test[value:(cutPoints[which(cutPoints == value) + 1] - 1)] 
                           }))
    return(toReturn)
  }
  
  evaluateSowToEow <- function(dataFrame, sowIndex, eowIndex) {
    timedifference <- as.double(dataFrame$datetimeutc[eowIndex] - dataFrame$datetimeutc[sowIndex], "secs")
    maxspeed <- max(dataFrame$speedmps[sowIndex:eowIndex])
    return(timedifference >= 60 && maxspeed < 2.78)
  }
  
  evaluateEowToSow <- function(dataFrame, eowIndex, sowIndex) {
    timedifference <- as.double(dataFrame$datetimeutc[sowIndex] - dataFrame$datetimeutc[eowIndex], "secs")
    return(timedifference >= 120)
  }
  
  # Add a row to a dataframe faster than rbind according to http://stackoverflow.com/questions/11561856/add-new-row-to-dataframe
  # existingDF = data frame
  # newrow = row contents
  # r = index to insert row at
  # It's called insertRow"2" because that's what it is called on the webpage referenced above
  insertRow2 <- function(existingDF, newrow, r) {
    if (nrow(existingDF) == 0) {
      # rbind will strip columns out of an empty DF and rename them, so sidestep rbind if no rows
      existingDF[1,] <- newrow
      return(existingDF)
    }
    existingDF <- rbind(existingDF,newrow)
    existingDF <- existingDF[order(c(1:(nrow(existingDF)-1),r-0.5)),]
    row.names(existingDF) <- 1:nrow(existingDF)
    return(existingDF)  
  }
  
  tripData$eow <- getEow(tripData)
  tripData$sow <- getSow(tripData)
  tripData$modeendpoint <- getModeEndPoints(tripData)
  tripData$modesegmentid <- getModeSegmentIDs(tripData)
  sowindexes <- which(tripData$modeendpoint == "SOW")
  eowindexes <- which(tripData$modeendpoint == "EOW")
  walksegments <- data.frame(startindex=sowindexes,endindex=eowindexes)
  if (nrow(walksegments) == 0) {
    # No mode changes detected
    # set everything as nonwalk
    nonwalksegments <- data.frame(startindex=1, endindex=nrow(tripData))
    nonwalksegments$mode <- 'nonwalk'
    # All segments are nonwalk
    segments <- nonwalksegments
  } else {
    # Common case with at least some mode detection
    nonwalksegments <- data.frame(startindex=head(eowindexes, -1) + 1, endindex=tail(sowindexes, -1) - 1)
    # Remove nonwalksegments where the trip ends, so two walk segments should be next to each other
    # (One is the walking end of a trip, the next is the walking beginning of the next trip)
    nonwalksegments <- subset(nonwalksegments, startindex <= endindex)
    
    # Add first segment to nonwalksegments
    if (is.na(tripData$modeendpoint[1]) || tripData$modeendpoint[1] != "SOW") {
      nonwalksegments <- insertRow2(nonwalksegments, 
                                   c(1, head(walksegments$startindex, 1) - 1), 
                                   1)
    }
    # Add last segment to nonwalksegments
    if (is.na(tripData$modeendpoint[1]) || tripData$modeendpoint[nrowdata] != "EOW") {
      nonwalksegments <- insertRow2(nonwalksegments, 
                                   c(tail(walksegments$endindex, 1) + 1, nrowdata), 
                                   nrow(nonwalksegments))
    }
    if (nrow(walksegments) > 0) walksegments$mode <- 'walk'
    if (nrow(nonwalksegments) > 0) nonwalksegments$mode <- 'nonwalk'
    segments <- merge(walksegments, nonwalksegments, all=TRUE)
  }
  
  segments$starttime <- tripData[segments$startindex, 'datetimeutc']
  segments$endtime <- tripData[segments$endindex, 'datetimeutc']
  segments$startlat <- tripData[segments$startindex, 'lat']
  segments$startlong <- tripData[segments$startindex, 'long']
  segments$endlat <- tripData[segments$endindex, 'lat']
  segments$endlong <- tripData[segments$endindex, 'long']
  
  segments$distancemeters <- NA
  segments$travtimeminutes <- round(difftime(segments$endtime, segments$starttime, units="mins"), digits = 2)
  for (index in 1:nrow(segments)) {
    segments[index, 'distancemeters'] <- round(sum(getDeltaDistanceMetersBetweenAdjacent(tripData[segments[index,'startindex']:segments[index,'endindex'], 'long'], tripData[segments[index,'startindex']:segments[index,'endindex'], 'lat'])), digits = 0);
  }
  segments$avgspeedkph <- round((segments$distancemeters / 1000) / as.numeric(segments$travtimeminutes / 60), digits = 2)
  
 
  nonwalkIndexes <- which(segments$mode=="nonwalk")
  if (any((nonwalkIndexes - 1) %in% nonwalkIndexes)) {
    stop("Subsequent Non-walks")
  }
  return(segments)
}