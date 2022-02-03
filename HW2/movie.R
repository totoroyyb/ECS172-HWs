load('data/ml100kpluscovs.RData')

# # Data Processing & Generating New Variables 
# Genre <- matrix(, nrow = length(unique(ml100kpluscovs$user)), ncol = 19)
# for (i in 1:length(unique(ml100kpluscovs$user))){
#     Genre[i, 1] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G1 == 1, 'rating'])
#     Genre[i, 2] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G2 == 1, 'rating'])
#     Genre[i, 3] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G3 == 1, 'rating'])
#     Genre[i, 4] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G4 == 1, 'rating'])
#     Genre[i, 5] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G5 == 1, 'rating'])
#     Genre[i, 6] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G6 == 1, 'rating'])
#     Genre[i, 7] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G7 == 1, 'rating'])
#     Genre[i, 8] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G8 == 1, 'rating'])
#     Genre[i, 9] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G9 == 1, 'rating'])
#     Genre[i, 10] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G10 == 1, 'rating'])
#     Genre[i, 11] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G11 == 1, 'rating'])
#     Genre[i, 12] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G12 == 1, 'rating'])
#     Genre[i, 13] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G13 == 1, 'rating'])
#     Genre[i, 14] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G14 == 1, 'rating'])
#     Genre[i, 15] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G15 == 1, 'rating'])
#     Genre[i, 16] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G16 == 1, 'rating'])
#     Genre[i, 17] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G17 == 1, 'rating'])
#     Genre[i, 18] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G18 == 1, 'rating'])
#     Genre[i, 19] <- mean(ml100kpluscovs[ml100kpluscovs$user == i & ml100kpluscovs$G19 == 1, 'rating'])
# }

# Genre_Mean <- c()
# for (i in 1:length(ml100kpluscovs$user)){
#     mean <- 0
#     num_genre <- 0
#     if (ml100kpluscovs[i, 'G1'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 1]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G2'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 2]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G3'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 3]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G4'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 4]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G5'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 5]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G6'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 6]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G7'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 7]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G8'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 8]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G9'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 9]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G10'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 10]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G11'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 11]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G12'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 12]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G13'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 13]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G14'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 14]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G15'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 15]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G16'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 16]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G17'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 17]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G18'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 18]
#         num_genre <- num_genre + 1
#     }
#     if (ml100kpluscovs[i, 'G19'] == 1){
#         mean <- mean + Genre[ml100kpluscovs[i, 'user'], 19]
#         num_genre <- num_genre + 1
#     }
#     Genre_Mean <- c(Genre_Mean, mean/num_genre) 
# }

# Age <- matrix(, nrow = length(unique(ml100kpluscovs$item)), ncol = 14)
# for (i in 1:length(unique(ml100kpluscovs$item))){
#     Age[i, 1] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 7 & ml100kpluscovs$age <= 15, 'rating'])
#     Age[i, 2] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 16 & ml100kpluscovs$age <= 25, 'rating'])
#     Age[i, 3] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 26 & ml100kpluscovs$age <= 35, 'rating'])
#     Age[i, 4] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 36 & ml100kpluscovs$age <= 45, 'rating'])
#     Age[i, 5] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 46 & ml100kpluscovs$age <= 55, 'rating'])
#     Age[i, 6] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 56 & ml100kpluscovs$age <= 65, 'rating'])
#     Age[i, 7] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'M' & ml100kpluscovs$age >= 66 & ml100kpluscovs$age <= 73, 'rating'])
#     Age[i, 8] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 7 & ml100kpluscovs$age <= 15, 'rating'])
#     Age[i, 9] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 16 & ml100kpluscovs$age <= 25, 'rating'])
#     Age[i, 10] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 26 & ml100kpluscovs$age <= 35, 'rating'])
#     Age[i, 11] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 36 & ml100kpluscovs$age <= 45, 'rating'])
#     Age[i, 12] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 46 & ml100kpluscovs$age <= 55, 'rating'])
#     Age[i, 13] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 56 & ml100kpluscovs$age <= 65, 'rating'])
#     Age[i, 14] <- mean(ml100kpluscovs[ml100kpluscovs$item == i & ml100kpluscovs$gender == 'F' & ml100kpluscovs$age >= 66 & ml100kpluscovs$age <= 73, 'rating'])
# }

# Age_Mean <- c()
# for (i in 1:length(ml100kpluscovs$user)){
#     if (ml100kpluscovs[i, 'gender'] == 'M'){
#         if (ml100kpluscovs[i, 'age'] >= 7 & ml100kpluscovs[i, 'age'] <= 15){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 1])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 16 & ml100kpluscovs[i, 'age'] <= 25){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 2])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 26 & ml100kpluscovs[i, 'age'] <= 35){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 3])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 36 & ml100kpluscovs[i, 'age'] <= 45){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 4])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 46 & ml100kpluscovs[i, 'age'] <= 55){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 5])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 56 & ml100kpluscovs[i, 'age'] <= 65){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 6])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 66 & ml100kpluscovs[i, 'age'] <= 73){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 7])
#         }
#     } else {
#         if (ml100kpluscovs[i, 'age'] >= 7 & ml100kpluscovs[i, 'age'] <= 15){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 8])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 16 & ml100kpluscovs[i, 'age'] <= 25){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 9])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 26 & ml100kpluscovs[i, 'age'] <= 35){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 10])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 36 & ml100kpluscovs[i, 'age'] <= 45){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 11])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 46 & ml100kpluscovs[i, 'age'] <= 55){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 12])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 56 & ml100kpluscovs[i, 'age'] <= 65){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 13])
#         }
#         if (ml100kpluscovs[i, 'age'] >= 66 & ml100kpluscovs[i, 'age'] <= 73){
#             Age_Mean <- c(Age_Mean, Age[ml100kpluscovs[i, 'item'], 14])
#         }
#     }
# }

# ml100kpluscovs$userMean_perGenre <- Genre_Mean
# ml100kpluscovs$itemMean_perTypeOfUser <- Age_Mean
# save(ml100kpluscovs, file = 'data/ml100kpluscovs.RData')

# Test Model Accuracy
baseAcc <- 0
testAcc <- 0 
for (i in 1:100) {
    movieLin0 <- qeLin(ml100kpluscovs[,c('rating', 'userMean_perGenre', 'itemMean_perTypeofUser')], 'rating')
    baseAcc <- baseAcc + movieLin0$baseAcc
    testAcc <- testAcc + movieLin0$testAcc
}
ba <- baseAcc/100
ta <- testAcc/100
cat('base accuracy: ', ba)
cat('test accuracy: ', ta)