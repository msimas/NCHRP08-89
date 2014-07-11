# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# install.packages("fields")
#library(fields)
#install.packages(geosphere)
library(geosphere)
distanceMetersCore <- function(fromlong, fromlat, tolong, tolat) {
  #toReturn <- rdist.earth(cbind(fromlong, fromlat), 
  #                        cbind(tolong, tolat),
  #                        miles=FALSE) * 1000 #4.26 at 50reps of 4064 line file
  #toReturn <- distCosine(c(fromlong, fromlat), c(tolong, tolat)) #3.42 secs at 50reps of 4064 line file
  #toReturn <- distHaversine(c(fromlong, fromlat), c(tolong, tolat)) #3.47 secs at 50reps of 4064 line file
  toReturn <- distVincentySphere(c(fromlong, fromlat), c(tolong, tolat)) #3.49 secs at 50reps of 4064 line file
}

getDeltaDistanceMeters <- function(fromlong, fromlat, tolong, tolat) {
  if (length(fromlong) > 1) 
  {
    # rdist.earth doesn't play nice with vectors, so this breaks them apart before calling it
    # By "doesn't play nice" I mean it will give the distances between each pair of coordinates
    # The common case is we only want the distances between adjacent coordinates (see below)
    return(mapply(getDeltaDistanceMeters, fromlong, fromlat, tolong, tolat))
  }
  toReturn <- distanceMetersCore(fromlong, fromlat, tolong, tolat)
  return(toReturn)
}

getDeltaDistanceMetersBetweenAdjacent <- function(longitude, latitude) {
  if (length(longitude) != length(latitude)) {
    stop("longitude and latitude vectors are different lengths (" + length(longitude) + "," + length(latitude) + ")")
  }
  if (length(longitude) == 1) return(0)
  return(getDeltaDistanceMeters(head(longitude, -1), 
                                head(latitude, -1), 
                                tail(longitude, -1), 
                                tail(latitude, -1)))
}