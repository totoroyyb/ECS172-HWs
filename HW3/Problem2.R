# require(regtools)
# require(rectools)
# require(qeML)

prep_data <- function(data_dir = "./data/") {
    url <- "http://www2.informatik.uni-freiburg.de/~cziegler/BX/BX-CSV-Dump.zip"
    temp <- tempfile()
    download.file(url, dest = temp)
    unzip(temp, exdir = data_dir)
}

# prep_data()

# # Load Data 
# library(data.table)
# options(warn=-1)
# Users <- fread('./data/BX-Users.csv', sep=';')
# Books <- fread('./data/BX-Books.csv', sep=';')
# Books_Ratings <- fread('./data/BX-Book-Ratings.csv', sep=';')
# options(warn=0)

# # Due to memory limitation, we need only a subset of dataset, here the subset is the first 50000 users with all books
# Num_Users = 50000
# Books_User = unique(Books_Ratings[`User-ID` <= Num_Users & `Book-Rating` != 0, `User-ID`]) #14009
# Books_ISBN = unique(Books_Ratings[`User-ID` <= Num_Users & `Book-Rating` != 0, ISBN]) #54399

# # Create training and testing set with all all-NA cols and rows removed
# Row <- c()
# Col <- c()
# Total_Ratings <- length(Books_Ratings[`User-ID` <= Num_Users & `Book-Rating` != 0, `User-ID`])
# Test_Frac <- 0.2
# Test_Ratings <- floor(Total_Ratings * Test_Frac)
# Test_Num <- 0
# Test_Row_Index <- c()
# Test_Col_Index <- c()
# Test_Value <- c()
# Train_Row_Index <- c()
# Train_Col_Index <- c()
# Train_Value <- c()
# mean_ratings <- 7.492232

# Rating_Matrix <- matrix(NA, nrow = length(Books_User), ncol = length(Books_ISBN))
# for (index in 1:dim(Books_Ratings)[1]) {
#     if (Books_Ratings$`User-ID`[index] <= Num_Users & Books_Ratings$`Book-Rating`[index] != 0) {
#         row <- match(Books_Ratings$`User-ID`[index], Books_User)
#         col <- match(Books_Ratings$ISBN[index], Books_ISBN)
#         if (!(row %in% Row) | !(col %in% Col) | (Test_Num == Test_Ratings)) {
#             Rating_Matrix[row, col] <- Books_Ratings$`Book-Rating`[index]
#             Train_Row_Index <- c(Train_Row_Index, row)
#             Train_Col_Index <- c(Train_Col_Index, col)
#             Train_Value <- c(Train_Value, Books_Ratings$`Book-Rating`[index])
#             if (!(row %in% Row)) {
#                 Row <- c(Row, row)
#             }
#             if (!(col %in% Col)) {
#                 Col <- c(Col, col)
#             }
#         } else {
#             Test_Row_Index <- c(Test_Row_Index, row)
#             Test_Col_Index <- c(Test_Col_Index, col)
#             Test_Value <- c(Test_Value, Books_Ratings$`Book-Rating`[index])
#             Test_Num <- Test_Num + 1
#         }
#     }
# }

# mean_row_ratings <- c()
# mean_col_ratings <- c()
# for (index in 1:length(unique(Books_Ratings[`User-ID` <= Num_Users & `Book-Rating` != 0, `User-ID`]))){
#     mean_row_ratings <- c(mean_row_ratings, mean(Train_Value[which(Train_Row_Index==index)]))
# }
# for (index in 1:length(unique(Books_Ratings[`User-ID` <= Num_Users & `Book-Rating` != 0, ISBN]))){
#     mean_col_ratings <- c(mean_col_ratings, mean(Train_Value[which(Train_Col_Index==index)]))
# }

# Row <- c()
# Col <- c()
# Test_Num <- 0
# Train_biasRemoved_Value <- c()
# Rating_Matrix_biasRemoved <- matrix(NA, nrow = length(Books_User), ncol = length(Books_ISBN))
# for (index in 1:dim(Books_Ratings)[1]) {
#     if (Books_Ratings$`User-ID`[index] <= Num_Users & Books_Ratings$`Book-Rating`[index] != 0) {
#         row <- match(Books_Ratings$`User-ID`[index], Books_User)
#         col <- match(Books_Ratings$ISBN[index], Books_ISBN)
#         if (!(row %in% Row) | !(col %in% Col) | (Test_Num == Test_Ratings)) {
#             Rating_Matrix_biasRemoved[row, col] <- Books_Ratings$`Book-Rating`[index] + mean_ratings - mean_row_ratings[row] - mean_col_ratings[col]
#             Train_biasRemoved_Value <- c(Train_biasRemoved_Value, Books_Ratings$`Book-Rating`[index] + mean_ratings - mean_row_ratings[row] - mean_col_ratings[col])
#             if (!(row %in% Row)) {
#                 Row <- c(Row, row)
#             }
#             if (!(col %in% Col)) {
#                 Col <- c(Col, col)
#             }
#         } else {
#             Test_Num <- Test_Num + 1
#         }
#     }
# }

# Rating_Matrix_Train_Frame <- data.frame(matrix(ncol=3, nrow=length(Train_Value)))
# colnames(Rating_Matrix_Train_Frame) <- c("user", "ISBN", "rating")
# Rating_Matrix_Train_Frame$user <- Train_Row_Index
# Rating_Matrix_Train_Frame$ISBN <- Train_Col_Index
# Rating_Matrix_Train_Frame$rating <- Train_Value
# write.table(Rating_Matrix_Train_Frame, "train.txt", row.names = FALSE, col.names = FALSE)

# Rating_Matrix_Test_Frame <- data.frame(matrix(ncol=2, nrow=length(Test_Value)))
# colnames(Rating_Matrix_Test_Frame) <- c("user", "ISBN")
# Rating_Matrix_Test_Frame$user <- Test_Row_Index
# Rating_Matrix_Test_Frame$ISBN <- Test_Col_Index
# write.table(Rating_Matrix_Test_Frame, "test.txt", row.names = FALSE, col.names = FALSE)

# Rating_Matrix_Train_biasRemoved_Frame <- data.frame(matrix(ncol=3, nrow=length(Train_Value)))
# colnames(Rating_Matrix_Train_biasRemoved_Frame) <- c("user", "ISBN", "rating")
# Rating_Matrix_Train_biasRemoved_Frame$user <- Train_Row_Index
# Rating_Matrix_Train_biasRemoved_Frame$ISBN <- Train_Col_Index
# Rating_Matrix_Train_biasRemoved_Frame$rating <- Train_biasRemoved_Value
# write.table(Rating_Matrix_Train_biasRemoved_Frame, "train_biasRemoved.txt", row.names = FALSE, col.names = FALSE)

Rating_Matrix_Train_covRemoved_Frame <- data.frame(matrix(ncol=2, nrow=length(Train_Value)))
colnames(Rating_Matrix_Train_covRemoved_Frame) <- c("user", "rating")
Rating_Matrix_Train_covRemoved_Frame$user <- as.character(Train_Row_Index)
Rating_Matrix_Train_covRemoved_Frame$rating <- Train_Value

lmout <- lm(rating ~ user, Rating_Matrix_Train_covRemoved_Frame)

# pritn(lmout)


# Softimpute Package
# library(softImpute)
# showClass("Incomplete")
# Rating_Matrix_Incomplete <- as(Rating_Matrix, "Incomplete")

# fit <- softImpute(Rating_Matrix_Incomplete, rank.max = 200, lambda = 50,
# type = "als", thresh = 1e-03, maxit = 100, trace.it = TRUE,
# warm.start = NULL, final.svd = TRUE)

# fitd <- deBias(Rating_Matrix_Incomplete, fit)

# predictions <- impute(fit, i=Test_Row_Index, j=Test_Col_Index)
# print(mean(abs(predictions - Test_Value)))

# Rating_Matrix_biasRemoved_Incomplete <- as(Rating_Matrix_biasRemoved, "Incomplete")

# fit_biasRemoved <- softImpute(Rating_Matrix_biasRemoved_Incomplete, rank.max = 200, lambda = 50,
# type = "als", thresh = 1.1e-03, maxit = 1, trace.it = TRUE,
# warm.start = NULL, final.svd = TRUE)

# predictions <- impute(fit_biasRemoved, i=Test_Row_Index, j=Test_Col_Index)
# predictions <- predictions + mean_row_ratings[Test_Row_Index] + mean_col_ratings[Test_Col_Index] - mean_ratings
# print(mean(abs(predictions - Test_Value)))

# Recosystem Package
# library(recosystem)
# set.seed(123)

# train_set <- data_file("train.txt")
# test_set <- data_file("test.txt")
# r <- Reco()
# opts <- r$tune(train_set, opts = list(dim = c(10, 20, 30), lrate = c(0.1, 0.2),
#                                      costp_l1 = 0, costq_l1 = 0,
#                                      nthread = 1, niter = 10))
# r$train(train_set, opts = c(opts$min, nthread = 1, niter = 10))
# pred_file = tempfile()
# r$predict(test_set, out_file(pred_file))
# print(mean(abs(scan(pred_file)-Test_Value)))

# train_set <- data_file("train_biasRemoved.txt")
# test_set <- data_file("test.txt")
# r <- Reco()
# opts <- r$tune(train_set, opts = list(dim = c(10, 20, 30), lrate = c(0.1, 0.2),
#                                      costp_l1 = 0, costq_l1 = 0,
#                                      nthread = 1, niter = 10))
# r$train(train_set, opts = c(opts$min, nthread = 1, niter = 10))
# pred_file = tempfile()
# r$predict(test_set, out_file(pred_file))
# print(mean(abs(scan(pred_file)+mean_row_ratings[Test_Row_Index]+mean_col_ratings[Test_Col_Index]-mean_ratings-Test_Value)))