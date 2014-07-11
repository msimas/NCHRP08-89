# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

#constants
kernelBandwidth <- 10
maxCalculatedSpeed <- 50
maxCalculatedAccel <- 10
#for atlanta
minHeight <- 738
maxHeight <- 1050

smoothPoints <- function(time, times, coords) {
  return(
    sum(gaussianKernelFunction(time, times) * coords) / 
           sum(gaussianKernelFunction(time, times))
    )
}

gaussianKernelFunction <- function(time1, time2) {
  diff <- difftime(time1, time2, units='secs')
  secs <- as.numeric(diff)
  return(
    exp(
      -(
          (secs ^ 2) / 
          (2 * kernelBandwidth ^ 2)
      )
    )
  )
}

noiseFiltering_Schuessler_Axhausen <- function(data) {
  smoothedLat <- sapply(data$datetimeutc, smoothPoints, data$datetimeutc, data$lat)
  smoothedLong <- sapply(data$datetimeutc, smoothPoints, data$datetimeutc, data$long)
  
  data$noise <- data$speedmps > maxCalculatedSpeed | 
    data$accelmps2 > maxCalculatedAccel | 
    data$altitudefeet < minHeight | data$altitudefeet > maxHeight
  
  return(data)
}