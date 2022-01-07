# download.file("http://files.grouplens.org/datasets/movielens/ml-100k.zip", 'ml-100k.zip") # nolint
# unzip("ml-100k.zip") # nolint
ml100 <- read.csv("ml-100k/u.data", header = FALSE, sep = "\t")
colnames(ml100) <- c("user_id", "item_id", "rating", "timestamp")
rawData <- ml100[ , c("user_id", "timestamp")]
