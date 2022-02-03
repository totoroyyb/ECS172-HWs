load('./data/Hwk2.RData') #generation code is in the data folder
require(rectools)
require(qeML)
# data exploration

#check for NA values -> no NA values
which(is.na(house_vote), arr.ind=TRUE)
which(is.na(InstEval), arr.ind=TRUE)
which(is.na(ml100kpluscovs), arr.ind=TRUE)


printacc <- function(model) {
    cat("---printing accuracy scores for", deparse(substitute(model)), "---\n")
    cat("base accuracy: ", model$baseAcc, "\n")
    cat("test accuracy: ", model$testAcc, "\n")
}