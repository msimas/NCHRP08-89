


#rgps <- loadData('//DRAKE/nchrp-08-89-gps/Workspace/Task3/ArcWearGeneralTrainingData/RawPointFiles/4030262_P1.csv')
rgps <- loadData('//nas-04/ArchivedData/ArchivedProjects/AtlantaGPSTravelSurvey/OriginalData/Vehicle/4257225_V1.csv')
#rgps <- subset(rgps, long > -84.39343 & long > -84.38780 &  lat > 33.75315 & lat < 33.75959)

bbox <- c(min(rgps$long), min(rgps$lat), max(rgps$long), max(rgps$lat))
bbox <- c(-84.39343,33.75315,-84.38780,33.75959)

#bbox<-c(-84.402185,33.7545,-84.387185,33.792)

sfilter <- noiseFiltering_Schuessler_Axhausen(rgps)
lfilter <- noiseFiltering_Lawson(rgps)
stfilter <- noiseFiltering_Stopher(rgps)

plotGpsPoints(rgps, bbox)
ggsave(filename="raw.png")

plotGpsPoints(subset(sfilter, noise), bbox)
ggsave(filename="Images/Schuessler_Axhausen_noise2.png", dpi=150)

plotGpsPoints(subset(lfilter, noise), bbox)
ggsave(filename="Images/Lawson_noise2.png", dpi=150)

plotGpsPoints(subset(stfilter, noise), bbox)
ggsave(filename="Images/Stopher_noise2.png", dpi=150)


cgps <- subset(lfilter, !noise)

s_mode_seg <- modeTransitionIdentification_TsuiShalaby_SchuesslerAxhausen(cgps)
o_mode_seg <- modeTransitionIdentification_Oliveira(cgps)
t_mode_seg <- modeTransitionIdentification_TsuiShalaby_SchuesslerAxhausen(cgps)

w_trips <- tripIdentification_Wolf(subset(lfilter, !noise))

gpstrips <- w_trips

bbox <- c(min(gpstrips$startlong), min(gpstrips$startlat), max(gpstrips$startlong), max(gpstrips$startlat))
map <- qmap(bbox, zoom = 12)
map + geom_segment(aes(x=startlong,y=startlat, xend=endlong, yend=endlat, colour=factor(gpstripid), arrow = arrow(length = unit(0.25,"cm")), size = 0.05), data=gpstrips) + geom_text(aes(x=(startlong+endlong)/2, y=(startlat+endlat)/2, label=gpstripid), data = gpstrips) + scale_colour_brewer(palette="Set1")

