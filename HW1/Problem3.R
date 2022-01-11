# ml100kpluscovs <- getML100K() #load BuildML100KPlusCovs.R first

plotDensities <- function(inputDF, xName, grpName) {
    library(ggplot2)
    colors <- c("antiquewhite1", "aquamarine2", "bisque1", "cadetblue1",
                "chocolate2", "darkmagenta", "firebrick1", "darkseagreen2")
    for (i in 1:8) {
        curData <- inputDF[substr(inputDF[[grpName]], i, i) == "1",]
        curDen <- density(curData[[xName]])
        if (i == 1) {
            plot(curDen, ylim = c(0, 1.6), col = colors[i])
        } else {
            lines(curDen, ylim = c(0, 1.6), col = colors[i])
        }
    }
    legend(x = "topright", legend = c("genre 1", "genre 2", "genre 3",
    "genre 4", "genre 5", "genre 6", "genre 7", "genre 8"),
    col = colors, lwd = 2)
}

prep_data <- function(data_folder = "ml-100k") {
    movies_df <- read.table(
        file.path("ml-100k", "u.item"),
        header = FALSE,
        sep = "|",
        quote = ""
    )
    ml100 <- read.table(
        file.path("ml-100k", "u.data"),
        header = FALSE,
        sep = "\t"
    )
    colnames(ml100) <- c("user_id", "item_id", "rating", "timestamp")
    movies_df$genre <- paste0(movies_df$V6, movies_df$V7, movies_df$V8,
    movies_df$V9, movies_df$V10, movies_df$V11, movies_df$V12, movies_df$V13)
    ml100$genre <- lapply(ml100$item_id, function(id) movies_df$genre[id])
    return(ml100)
}

plotDensities(prep_data(), "rating", "genre")

# plotDensities(getML100K(), )