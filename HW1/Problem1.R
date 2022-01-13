# download.file("http://files.grouplens.org/datasets/movielens/ml-100k.zip", 'ml-100k.zip") # nolint
# unzip("ml-100k.zip") # nolint

ml100 <- read.csv("ml-100k/u.data", header = FALSE, sep = "\t")
colnames(ml100) <- c("user_id", "item_id", "rating", "timestamp")
rawData <- ml100[ , c("user_id", "timestamp")]

waitTimes <- function(rawData) {
    individuals <- c()
    listOfVecs <- list()
    # Iterate over each user
    for (i in 1:max(rawData$user_id)) {
        curData <- rawData[rawData$user_id == i,]$timestamp
        curData <- curData[order(curData)]
        curLeft <- curData[2:length(curData)]
        curMean <- mean(curLeft - curData[1:length(curLeft)])
        individuals <- c(individuals, curMean)
        listOfVecs[[i]] <- curData
    }
    # Collective
    curData <- mergeEm(listOfVecs)
    overall <- mean(curData[2:length(curData)] - curData[1:length(curData) - 1])
    return(list(individuals, overall))
}

a <- waitTimes(rawData)

mergeEm <- function(listOfVecs) {
    mergedVecs <- c()
    for (Vec in listOfVecs) {
        mergedVecs <- c(mergedVecs, Vec)
    }
    return(mergedVecs[order(mergedVecs)])
}
