require(rectools)
require(qeML)

##get the data
#InstEval
getInstEval()

#house_vote
colnames<- c('party', paste0(rep("B", 16), 1:16))
house_vote = read.csv('./data/house-votes-84.data', header = FALSE, col.names = colnames)
house_vote$voter_num <- c(as.integer(row.names(house_vote)) )

#take in a row vector and return a 16 * 19 vector
process_1_voter <- function(voter) {
  res <- c()
  for (billNum in 1:16) {
    curr_row <- c()
    curr_row <- c(billNum, voter[,(billNum + 1)], voter)#itemNum, User_party, vote(rating)
    res <- rbind(res, curr_row)
  }
  res
}

tmp <-data.frame()

for(i in 1:nrow(house_vote)){
  tmp <- rbind(tmp, process_1_voter(house_vote[i,])) 
}


colnames(tmp) <- c('bill_id', 'bill_rating', 'party',paste0(rep("B", 16), 1:16), 'voter_id')
rownames(tmp) <- c(1:nrow(tmp))
house_vote <- tmp
house_vote <- house_vote[, c(20, 1:19)]

sub <- function(x){
  if(x=='?'){
    x <- 'u'
  }
  x
}

house_vote$bill_rating <- lapply(house_vote$bill_rating, sub)

for (i in 1:20) {
  house_vote[, i] <- as.factor(as.character(house_vote[, i]))
  print(class(house_vote[, i]))
}

#ml100kpluscovs
load('dataHwk1.RData')

save(ml100, ml100kpluscovs, house_vote, InstEval, file = 'Hwk2.RData')
save(InstEval, file = 'InstEval.RData')
save(house_vote, file = '.house_vote.RData')

## data exploration

# check for NA values -> no NA values
which(is.na(house_vote), arr.ind=TRUE)
which(is.na(InstEval), arr.ind=TRUE)
which(is.na(ml100kpluscovs), arr.ind=TRUE)

# utility function
printacc <- function(model) {
    cat("---printing accuracy scores for", deparse(substitute(model)), "---\n")
    cat("base accuracy: ", model$baseAcc, "\n")
    cat("test accuracy: ", model$testAcc, "\n")
}
