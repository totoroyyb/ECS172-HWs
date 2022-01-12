# loading in TA's script
# library(ggplot2)
load("Hwk1.RData")
ml100kpluscovs$genre <- paste0(ml100kpluscovs$G1, ml100kpluscovs$G2, ml100kpluscovs$G3,
                               ml100kpluscovs$G4, ml100kpluscovs$G5, ml100kpluscovs$G6, ml100kpluscovs$G7, ml100kpluscovs$G8)

plotDensities <- function(inputDF, xName, grpName) {
    
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


plotDensities(ml100kpluscovs, "rating", "genre")