# download.file("http://files.grouplens.org/datasets/movielens/ml-100k.zip", 'ml-100k.zip") # nolint
# unzip("ml-100k.zip") # nolint

ml100 <- read.csv("ml-100k/u.data", header = FALSE, sep = "\t")
colnames(ml100) <- c("user_id", "item_id", "rating", "timestamp")
rawData <- ml100[ , c("user_id", "timestamp")]

waitTimes <- function(rawData) {
    # sort by timestamp
    newData <- rawData[order(rawData$timestamp),]
    individuals <- c()
    # Iterate over each user
    for (i in 1:max(newData$user_id)) {
        curData <- newData[newData$user_id == i,]$timestamp
        curLeft <- curData[2:length(curData)]
        curMean <- mean(curLeft - curData[1:length(curLeft)])
        individuals <- c(individuals, curMean)
    }

    # Collectively
    curData <- newData$timestamp
    overall <- mean(curData[2:length(curData)] - curData[1:length(curData) - 1])
    return(c(individuals, overall))
}

a <- waitTimes(rawData)
