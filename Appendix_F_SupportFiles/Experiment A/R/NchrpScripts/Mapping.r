# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

library(ggmap)

plotGpsPoints <- function(gps) {
  bbox <- c(min(gps$long), min(gps$lat), max(gps$long), max(gps$lat))
  plotGpsPoints(gps, bbox)
}

plotGpsPoints <- function(gps, bbox) {
  map <- qmap(bbox, zoom = 15)
  map + labs(x = "Longitude", y="Latitude")
  map + geom_point(aes(long,lat, colour=speedmph, size=2, alpha=0.25), data=gps) + scale_colour_gradient(low="red", high="green")
  #map + geom_point(aes(long,lat, size=2, alpha=0.25), data=gps, colour=I("blue"))
}

plotGpsTrips <- function(gpstrips, bbox) {
  map <- qmap(bbox, zoom = 12)
  map + geom_line(aes(x=startlong,y=startlat, xend=endlong, yend=endlat, colour=factor(gpstripid), size=deltaseconds, alpha=0.75), data=gpstrips) + scale_colour_brewer(palette="Set1")
  map + geom_text(aes(x=endlong, y=endlat, label=gpstripid))
}

plotGpsTrips <- function(gpstrips) {
  bbox <- c(min(gpstrips$startlong), min(gpstrips$startlat), max(gpstrips$startlong), max(gpstrips$startlat))
  plotGpsTrips(gpstrips, bbox)
}
