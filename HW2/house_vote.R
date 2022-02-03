load('./data/house_vote.RData')
require(rectools)
require(qeML)
head(house_vote)
# head(house_vote)
# ncol(house_vote)


# hv_comp <- qeCompare(house_vote[, 1:3], "bill_rating", c('qeLogit', 'qeKNN','qeRF'), 25)


#model 0 and 1 are predicting rating using party and G1-16
hvLog0 <- qeLogit(house_vote[, 3:20], "bill_rating")
printacc(hvLog0)

# build separate model for each party
dep_data <- subset(house_vote, house_vote$party == "democrat")
rep_data <- subset(house_vote, house_vote$party == "republican")
hvLog1_dep <- qeLogit(dep_data[, c(3, 5:20)], "bill_rating")
printacc(hvLog1_dep)
hvLog1_rep <- qeLogit(rep_data[, c(3, 5:20)], "bill_rating")
printacc(hvLog1_rep)

# voter_id bill_id bill_rating
hvLin0 <- qeLin(house_vote[, 1:3], "bill_rating")
printacc(hvLin0)

# voter_id bill_id bill_rating party
hvLin1 <- qeLin(house_vote[, 1:3], "bill_rating")
printacc(hvLin1)

# bill_id bill_rating party
hvLin2 <- qeLin(house_vote[, 2:4], "bill_rating")
printacc(hvLin2)
#predict(hvLog0, house_vote[1, 4:20])
