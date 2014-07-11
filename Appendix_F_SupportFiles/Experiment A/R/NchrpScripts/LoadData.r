# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

loadData <- function(filepath) {
  data <- read.csv(
    filepath,
    header=FALSE,
    col.names = c("valid", "lat", "ns", "long", "ew", "timeutc", "dateutc", "speedmph", "heading", "altitudefeet", "hdop", "nbsat")
  )
  nrowdata <- nrow(data)
  # Add negative if appropriate (the value to multiply by is either -1 {-2+1} or 1 {0+1})
  data$long <- abs(data$long) * ((-2 * (data$ew == "W")) + 1)
  data$lat <- abs(data$lat) * ((-2 * (data$ns == "S")) + 1)
  data$datetimeutc <- as.POSIXct(strptime(paste(sprintf("%06d", as.numeric(data$dateutc)), 
                                     " ", 
                                     sprintf("%06d", as.numeric(data$timeutc))),
                                     "%d%m%y %H%M%S"), tz="UTC")
  data$speedmps <- 0.44704 * data$speedmph
  data$deltaseconds <- c(0, as.double(data[2:nrowdata,"datetimeutc"] - data[1:(nrowdata-1),"datetimeutc"], "secs"))
  data$accelmps2 <- c(0, (data[2:nrowdata, "speedmps"] - data[1:(nrowdata-1), "speedmps"]) / data[2:nrowdata, "deltaseconds"])
  return(data)
}