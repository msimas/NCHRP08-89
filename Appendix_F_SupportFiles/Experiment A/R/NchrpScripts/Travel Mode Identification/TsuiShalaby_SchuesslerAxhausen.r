# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# Depends on Mode Transition Identification/TsuiShalaby_SchuesslerAxhausen
# OR Travel Mode Identification/ModeSegmentLoadingFunctions

travelModeIdentification_TsuiShalaby_SchuesslerAxhausen <- function(segments, points) {

  getColumn <- function(func, column, ...)
  {
    getDataInRange <- function(row)
    {
      return(func(data[row['startindex']:row['endindex'], column], ...))
    }
    return(apply(segments, 1, getDataInRange))
  }
  
  data <- points
  
  segments$medianSpeed <- getColumn(median, 'speedmps')
  segments$percentile95Speed <- getColumn(quantile, 'speedmps', 0.95)
  segments$percentile95Accel <- getColumn(quantile, 'accelmps2', 0.95)
  
  # Ties are broken by picking randomly 
  # This line ensures that the same random choices will be made each time, and therefore the experiment is repeatable
  set.seed(1)
  
  library(rJava)
  .jpackage("pkg", jars='*', morePaths='//drake/NCHRP-08-89-GPS/Workspace/Task3/FuzzyEngineGeoStatsMod.jar')
  fuzzyEngine <- .jnew("fuzzy.FuzzyEngine")
  medianSpeedVar <- .jnew("fuzzy.LinguisticVariable", "medianSpeed")
  percentileAcceleration95Var <- .jnew("fuzzy.LinguisticVariable", "95pAccel")
  percentileSpeed95Var <- .jnew("fuzzy.LinguisticVariable", "95pSpeed")
  modeVar <- .jnew("fuzzy.LinguisticVariable", "Mode")
  .jcall(medianSpeedVar, "V", "add", "VeryLow", 0, 0, 1.5, 2)
  .jcall(medianSpeedVar, "V", "add", "Low", 1.50, 2, 4, 6)
  .jcall(medianSpeedVar, "V", "add", "Medium", 5, 7, 11, 15)
  .jcall(medianSpeedVar, "V", "add", "High", 12, 15, 9999, 9999)
  .jcall(medianSpeedVar, "V", "add", "Low", 1.50, 2, 4, 6)
  # NOTE: 95th percentile acceleration was (0, 0, 0.5, 0.6) in the paper but we have negative 95th percentile accelerations (mostly decelerating for whole mode), so we use -9999 to cover these cases
  .jcall(percentileAcceleration95Var, "V", "add", "Low", -9999, -9999, 0.5, 0.6)
  .jcall(percentileAcceleration95Var, "V", "add", "Medium", 0.5, 0.7, 1, 1.2)
  .jcall(percentileAcceleration95Var, "V", "add", "High", 1, 1.5, 9999, 9999)
  .jcall(percentileSpeed95Var, "V", "add", "Low", 0, 0, 6, 8)
  .jcall(percentileSpeed95Var, "V", "add", "Medium", 7.5, 9.5, 15, 18)
  .jcall(percentileSpeed95Var, "V", "add", "High", 15, 20, 9999, 9999)
  .jcall(modeVar, "V", "add", "walk", 0, 1, 1, 2)
  .jcall(modeVar, "V", "add", "bike", 2, 3, 3, 4)
  .jcall(modeVar, "V", "add", "car", 4, 5, 5, 6)
  .jcall(modeVar, "V", "add", "bus", 6, 7, 7, 8)
  .jcall(modeVar, "V", "add", "rail", 8, 9, 9, 10)
  .jcall(fuzzyEngine, "V", "register", medianSpeedVar)
  .jcall(fuzzyEngine, "V", "register", percentileAcceleration95Var)
  .jcall(fuzzyEngine, "V", "register", percentileSpeed95Var)
  .jcall(fuzzyEngine, "V", "register", modeVar)
  
  rules <- c("if medianSpeed is VeryLow and 95pAccel is Low then Mode is walk",
            "if medianSpeed is VeryLow and 95pAccel is Medium then Mode is bike",
            "if medianSpeed is VeryLow and 95pAccel is High then Mode is bike",
            "if medianSpeed is Low and 95pAccel is Low and 95pSpeed is Low then Mode is bike",
            "if medianSpeed is Low and 95pAccel is Low and 95pSpeed is Medium then Mode is bus",
            "if medianSpeed is Low and 95pAccel is Low and 95pSpeed is High then Mode is car",
            "if medianSpeed is Low and 95pAccel is Medium then Mode is bus",
            "if medianSpeed is Low and 95pAccel is High and 95pSpeed is Low then Mode is bus",
            "if medianSpeed is Low and 95pAccel is High and 95pSpeed is Medium then Mode is car",
            "if medianSpeed is Low and 95pAccel is High and 95pSpeed is High then Mode is car",
            "if medianSpeed is Medium and 95pAccel is Low then Mode is bus",
            "if medianSpeed is Medium and 95pAccel is Medium then Mode is car",
            "if medianSpeed is Medium and 95pAccel is High then Mode is car",
            "if medianSpeed is High and 95pAccel is Low then Mode is rail",
            "if medianSpeed is High and 95pAccel is Medium then Mode is car",
            "if medianSpeed is High and 95pAccel is High then Mode is car")
  
  fbor <- .jnew("fuzzy.FuzzyBlockOfRules", rules)
  .jcall(fuzzyEngine, "V", "register", fbor)
  .jcall(fbor, "V", "parseBlock")
  
  runFuzzy <- function(medianSpeed, percentileAcceleration95, percentileSpeed95) {
    .jcall(medianSpeedVar, "V", "reset")
    .jcall(percentileAcceleration95Var, "V", "reset")
    .jcall(percentileSpeed95Var, "V", "reset")
    .jcall(modeVar, "V", "reset")
    
    .jcall(medianSpeedVar, "V", "setInputValue", medianSpeed)
    .jcall(percentileAcceleration95Var, "V", "setInputValue", percentileAcceleration95)
    .jcall(percentileSpeed95Var, "V", "setInputValue", percentileSpeed95)
    .jcall(fuzzyEngine, "V", "evaluateBlock", fbor)
    
    # .jrcall works better (but slower) than .jcall because the generic HashMap is causing trouble for .jcall
    result <- modeVar$defuzzifySeparately()
    # HashMap to R list from http://stackoverflow.com/questions/2249181/getting-a-hashmap-in-r-using-rjava
    keySet<-.jrcall(result, "keySet")
    an_iter<-.jrcall(keySet,"iterator")
    aList<-list()
    while(.jrcall(an_iter, "hasNext")) {
      key<-.jrcall(an_iter, "next");
      aList[[key]]<-.jrcall(result, "get", key)
    }
    winner <- pickWinner(aList)
    return(winner)
  }
  
  # TODO: Resolve answers
  # Pick greatest value
  # if tie, pick randomly between ties (there might be more than 2 ties)
  pickWinner <- function(alist) {
    vec <- unlist(alist)
    maxvalue <- max(vec)
    winners <- vec[which(vec == maxvalue)]
    winIndex <- 1
    if (length(winners) > 1) {
      # pick at random
      winIndex <- sample(1:length(winners), 1)
    }
    return(names(winners[winIndex]))
  }
  
  #walkTest <- runFuzzy(0, 0, 0)
  #bikeTest <- runFuzzy(3, 0, 0)
  #walkCycle <- sapply(1:10, function(x) { runFuzzy(1.75, 0, 0) })
  #walkCycle2 <- sapply(1:10, function(x) { runFuzzy(1.75, 0.55, 0) })
  
  segments$mode <- mapply(runFuzzy, segments$medianSpeed, segments$percentile95Accel, segments$percentile95Speed)
  return(segments)
}