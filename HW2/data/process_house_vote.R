bill_vote_toBinary <- function(vote){
  if(vote == 'y') 1
  else if(vote == 'n') 0
  else NA
  }

house_vote$handicapped.infants <- lapply(house_vote$party, partyToBinary)


#take in a row vector and return a 16 * 19 vector
process_1_voter <- function(voter, voterNum){
  res <- c()
  for (billNum in 1:16) {
    curr_row <- c(voterNum, billNum, voter[,1], voter[, billNum + 1],  )#userNum, itemNum, User_party, vote(rating)
  }
  
}


prep_houseData <- function(df){
  res <- c()
  # loop over each voter
  for(voter in df){
    print(head(voter))
    for (i in 2:17) {
      
    }
  }
}
house_vote = prep_houseData(house_vote)