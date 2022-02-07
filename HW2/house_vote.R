load('house_vote.RData')
load('house_vote_remove.RData')
require(rectools)
require(qeML)


# hv_comp <- qeCompare(house_vote[, 1:3], "bill_rating", c('qeLogit', 'qeKNN','qeRF'), 25)


#model 0 and 1 are predicting rating using party and G1-16
hvLog0 <- qeLogit(house_vote[, 3:20], "bill_rating")
printacc(hvLog0)

# build separate model for each party
dep_data <- subset(house_vote, house_vote$party == "democrat")
rep_data <- subset(house_vote, house_vote$party == "republican")
dep_hvLog0 <- qeLogit(dep_data[, c(3, 5:20)], "bill_rating")
rep_hvLog0 <- qeLogit(rep_data[, c(3, 5:20)], "bill_rating")
printacc(dep_hvLog0)
printacc(rep_hvLog0)

dep_Lin0 <- qeLin(dep_data[, c(3, 5:20)], "bill_rating")
printacc(dep_Lin0)
rep_Lin0 <- qeLin(rep_data[, c(3, 5:20)], "bill_rating")
printacc(rep_Lin0)

# voter_id bill_id bill_rating
hvLin0 <- qeLin(house_vote[, 1:3], "bill_rating")
printacc(hvLin0)

# voter_id bill_id bill_rating party
hvLin1 <- qeLin(house_vote[, 1:4], "bill_rating")
printacc(hvLin1)

# bill_id bill_rating party
hvLin2 <- qeLin(house_vote[, 2:4], "bill_rating")
printacc(hvLin2)



# # Genersting Useless Data
# house_vote_remove <- house_vote[house_vote$bill_rating != 'u', ]

# countYes <- function(votes) {
#     sum(votes == "y")
# }


# billtotalvotes = tapply(house_vote_remove$bill_rating, house_vote_remove$bill_id, length) 
# billyesvotes = tapply(house_vote_remove$bill_rating, house_vote_remove$bill_id, countYes)
# billyesvotespercent <- billyesvotes / billtotalvotes

# # reorder column
# # temp <- billyesvotespercent
# # temp[2:9] <- billyesvotespercent[9:16]
# # temp[9:16] <- billyesvotespercent[2:9]
# # billyesvotespercent <- temp
# # rownames(billyesvotespercent) <- c(1:16) #csj

# # bill_yesvotepercent <- c()
# # for (i in 1:length(house_vote_remove$voter_id)){
# #     if (house_vote_remove[i, 'bill_id'] == 1){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[1])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 2){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[2])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 3){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[3])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 4){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[4])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 5){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[5])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 6){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[6])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 7){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[7])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 8){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[8])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 9){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[9])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 10){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[10])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 11){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[11])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 12){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[12])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 13){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[13])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 14){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[14])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 15){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[15])
# #     }
# #     if (house_vote_remove[i, 'bill_id'] == 16){
# #         bill_yesvotepercent <- c(bill_yesvotepercent, billyesvotespercent[16])
# #     }
# # }

# # house_vote_remove$bill_yesvotepercent <- bill_yesvotepercent


# # # Generaitng Usefull Data
# # house_vote_remove <- house_vote[house_vote$bill_rating!='u', ]
# # save(house_vote_remove, file = 'data/house_vote_remove.RData')
# countYes <- function(votes){
#     sum(votes == 'y')
# }
# votertotalvotes = tapply(house_vote_remove$bill_rating, house_vote_remove$voter_id, length)
# voteryesvotes = tapply(house_vote_remove$bill_rating, house_vote_remove$voter_id, countYes)


# voteryesvotespercent = voteryesvotes / votertotalvotes
# index <- sort(as.integer(names(voteryesvotespercent)))
# sorted_voteryesvotespercent <- voteryesvotespercent[as.character(index)]
# sorted_voteryesvotespercent

# voter_yespercent <- c()
# for (i in 1:435){
#     for (j in 1:16){
#         voter_yespercent <- c(voter_yespercent, sorted_voteryesvotespercent[i])
#     }
# }

# house_vote$voter_yespercent <- voter_yespercent
# house_vote_remove <- house_vote[house_vote$bill_rating!='u', ]
# save(house_vote_remove, file = './data/house_vote_remove.RData')


# Test Model Accuracy
cat("Test Accuracy:", replicMeans(100, "qeLogit(house_vote_remove[,c('bill_id','bill_rating', 'voter_yespercent')], 'bill_rating')$testAcc"))
cat("Base Accuracy:", replicMeans(100, "qeLogit(house_vote_remove[,c('bill_id','bill_rating', 'voter_yespercent')], 'bill_rating')$baseAcc"))
