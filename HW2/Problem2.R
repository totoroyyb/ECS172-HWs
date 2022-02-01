load('Hwk2.RData') #generation code is in the data folder
require(rectools)
require(qeML)

# data exploration

#check for NA values -> no NA values
which(is.na(house_vote), arr.ind=TRUE)
which(is.na(InstEval), arr.ind=TRUE)
which(is.na(ml100kpluscovs), arr.ind=TRUE)

# data processing


# CF model
set.seed(9999)

movieLin0 <- qeLin(ml100kpluscovs[,c('user','item','rating')], 'rating')
cat('base accuracy: ', movieLin$baseAcc) 
cat('test accuracy: ', movieLin$testAcc)

movieLin1 <- qeLin(ml100kpluscovs[,c('user','item', 'age', 'rating')], 'rating')

# house_vote
# movieLin2 <- qeLogit(house_vote[,c('party','', 'rating')], 'rating')
