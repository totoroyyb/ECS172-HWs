require(regtools)
require(rectools)
require(qeML)
data(mlb)
data(pef)
mlb <- mlb[, 3:6]
mlbd <- factorsToDummies(mlb, omitLast = T)
mlbd <- as.data.frame(mlbd)

lmAlpha <- function(data, yName, nReplic, holdout) {
    pv <- sort(summary(qeLin(data, yName))$coefficients[, 4][-1])
    pv <- rownames(as.array(pv))
    all_cols <- list()
    for (n in 1:length(pv)) {
        these_cols <- list(pv[1:n], replicMeans(nReplic,
        "qeLin(data[, c(pv[1:n], yName)], yName, holdout)$testAcc"))
        names(these_cols) <- c("vars", "testAcc")
        all_cols[[n]] <- these_cols
    }
    all_cols
}

smallestMAPE <- function(feature_MAPE) {
    smallestMAPE <- list()
    smallestMAPE[[1]] <- feature_MAPE[1][[1]]$vars
    smallestMAPE[[2]] <- feature_MAPE[1][[1]]$testAcc[1]
    for (n in 2:length(feature_MAPE)) {
        if (feature_MAPE[n][[1]]$testAcc[1] < smallestMAPE[[2]]) {
            smallestMAPE[[1]] <- feature_MAPE[n][[1]]$vars
            smallestMAPE[[2]] <- feature_MAPE[n][[1]]$testAcc[1]
        }
    }
    smallestMAPE
}

# Demo For Test Result
feature_MAPE = lmAlpha(mlbd, "Weight", 50, 250)
print(feature_MAPE)
print(smallestMAPE(feature_MAPE))

# Analysis pef Dataset
pef <- pef[, c(1, 3:6)]
pefd <- factorsToDummies(pef, omitLast = T)
pefd <- as.data.frame(pefd)
feature_MAPE_pef = lmAlpha(pefd, "wageinc", 50, 250)
print(feature_MAPE_pef)
print(smallestMAPE(feature_MAPE_pef))



