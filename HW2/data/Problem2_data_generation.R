require(rectools)

#InstEval
getInstEval()

#house_vote
colnames<- c('party', paste0(rep("B", 16), 1:16))
house_vote = read.csv('house-votes-84.data', header = FALSE, col.names = colnames)
house_vote$voter_num <- c(as.integer(row.names(house_vote)) )

#take in a row vector and return a 16 * 19 vector
process_1_voter <- function(voter){
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

# house_vote[,3:20]=lapply(as.data.frame(house_vote[,3:20]), 'as.factor')



#ml100kpluscovs
load('Hwk1.RData')

save(ml100, ml100kpluscovs, house_vote, InstEval, file = 'Hwk2.RData')
