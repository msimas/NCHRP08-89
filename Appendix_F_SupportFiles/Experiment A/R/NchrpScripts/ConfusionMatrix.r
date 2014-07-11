# +---------------------------------------------------------+
# | NCHRP 08-89 R Scripts - Implemented by Westat,  Inc     |
# +---------------------------------------------------------+

# observed = vector of observed
# actual = vector of reference, must be the same length as observed
# categories = vector of possible values (levels() on a factor)
getConfusionMatrix <- function(observed, actual, categories) {
  if (length(categories) != length(unique(categories))) stop("categories are not unique")
  if (length(observed) != length(actual)) stop("observed and actual must be the same length")
  size <- length(categories)
  confusionMatrix <- matrix(nrow = size, ncol = size, dimnames=list(paste("reference", categories), paste("classified as", categories)))
  confusionMatrix[,] <- 0
  for (i in 1:length(observed)) {
    actualCatIndex <- which(categories == actual[i])
    if ((length(actualCatIndex) == 0) && is.na(actual[i])) actualCatIndex <- which(is.na(categories))
    if (length(actualCatIndex) == 0) stop(paste("actual value", actual[i], "not found in categories"))
    observedCatIndex <- which(categories == observed[i])
    if ((length(observedCatIndex) == 0) && is.na(observed[i])) observedCatIndex <- which(is.na(categories))
    if (length(observedCatIndex) == 0) stop(paste("observed value", observed[i], "not found in categories"))
    confusionMatrix[actualCatIndex, observedCatIndex] <- confusionMatrix[actualCatIndex, observedCatIndex] + 1
  }
  return(confusionMatrix)
}

