load('./data/InstEval.RData')
require(rectools)
require(qeML)
# set.seed(9999)

# head(InstEval)
# ncol(InstEval)

# InstLin0 <- qeLin(InstEval[,c('s','d','studage','lectage','service','dept')], 'y')
# cat('base accuracy: ', InstEvalRes$baseAcc) 
# cat('test accuracy: ', InstEvalRes$testAcc)

# Generating New Variables
# sy_mean <- c()
# for (i in 1:length(unique(InstEval$s))){
#     sy_mean <- c(sy_mean, mean(InstEval[InstEval$s == i, 'y']))
# }
# sy <- c()
# for (i in 1:length(InstEval$s)){
#     sy <- c(sy, sy_mean[InstEval[i, 's']])
# }
# InstEval$sy <- sy

# dy_mean <- vector(length=2160)
# for (i in 1:2160){
#     dy_mean[i] = mean(InstEval[as.integer(InstEval$d) == i, 'y'])
# }
# dy <- c()
# for (i in 1:length(InstEval$s)){
#     dy <- c(dy, dy_mean[as.integer(InstEval[i, 'd'])])
# }
# InstEval$dy <- dy

# s_lectage_mean <- matrix(, nrow = length(unique(InstEval$s)), ncol = 6)
# for (i in 1:length(unique(InstEval$s))){
#     s_lectage_mean[i, 1] = mean(InstEval[InstEval$s == i & InstEval$lectage == 1, 'y'])
#     s_lectage_mean[i, 2] = mean(InstEval[InstEval$s == i & InstEval$lectage == 2, 'y'])
#     s_lectage_mean[i, 3] = mean(InstEval[InstEval$s == i & InstEval$lectage == 3, 'y'])
#     s_lectage_mean[i, 4] = mean(InstEval[InstEval$s == i & InstEval$lectage == 4, 'y'])
#     s_lectage_mean[i, 5] = mean(InstEval[InstEval$s == i & InstEval$lectage == 5, 'y'])
#     s_lectage_mean[i, 6] = mean(InstEval[InstEval$s == i & InstEval$lectage == 6, 'y'])
# }

# s_lectage <- c()
# for (i in 1:length(InstEval$s)){
#     if (InstEval[i, 'lectage'] == 1){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 1])
#     }
#     if (InstEval[i, 'lectage'] == 2){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 2])
#     }
#     if (InstEval[i, 'lectage'] == 3){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 3])
#     }
#     if (InstEval[i, 'lectage'] == 4){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 4])
#     }
#     if (InstEval[i, 'lectage'] == 5){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 5])
#     }
#     if (InstEval[i, 'lectage'] == 6){
#         s_lectage <- c(s_lectage, s_lectage_mean[InstEval[i, 's'], 6])
#     }
# }

# InstEval$s_lectage <- s_lectage


# d_studage_mean <- matrix(, nrow = length(unique(InstEval$d)), ncol = 4)
# for (i in 1:length(unique(InstEval$d))){
#     d_studage_mean[i, 1] = mean(InstEval[as.integer(InstEval$d) == i & InstEval$studage == 2, 'y'])
#     d_studage_mean[i, 2] = mean(InstEval[as.integer(InstEval$d) == i & InstEval$studage == 4, 'y'])
#     d_studage_mean[i, 3] = mean(InstEval[as.integer(InstEval$d) == i & InstEval$studage == 6, 'y'])
#     d_studage_mean[i, 4] = mean(InstEval[as.integer(InstEval$d) == i & InstEval$studage == 8, 'y'])
# }

# d_studage <- c()
# for (i in 1:length(InstEval$s)){
#     if (InstEval[i, 'studage'] == 2){
#         d_studage <- c(d_studage, d_studage_mean[as.integer(InstEval[i, 'd']), 1])
#     }
#     if (InstEval[i, 'studage'] == 4){
#         d_studage <- c(d_studage, d_studage_mean[as.integer(InstEval[i, 'd']), 2])
#     }
#     if (InstEval[i, 'studage'] == 6){
#         d_studage <- c(d_studage, d_studage_mean[as.integer(InstEval[i, 'd']), 3])
#     }
#     if (InstEval[i, 'studage'] == 8){
#         d_studage <- c(d_studage, d_studage_mean[as.integer(InstEval[i, 'd']), 4])
#     }
# }

# InstEval$d_studage <- d_studage



# s_dept_mean <- matrix(, nrow = length(unique(InstEval$s)), ncol = 15)
# for (i in 1:length(unique(InstEval$s))){
#     s_dept_mean[i, 1] = mean(InstEval[InstEval$s == i & InstEval$dept == 1, 'y'])
#     s_dept_mean[i, 2] = mean(InstEval[InstEval$s == i & InstEval$dept == 2, 'y'])
#     s_dept_mean[i, 3] = mean(InstEval[InstEval$s == i & InstEval$dept == 3, 'y'])
#     s_dept_mean[i, 4] = mean(InstEval[InstEval$s == i & InstEval$dept == 4, 'y'])
#     s_dept_mean[i, 5] = mean(InstEval[InstEval$s == i & InstEval$dept == 5, 'y'])
#     s_dept_mean[i, 6] = mean(InstEval[InstEval$s == i & InstEval$dept == 6, 'y'])
#     s_dept_mean[i, 7] = mean(InstEval[InstEval$s == i & InstEval$dept == 7, 'y'])
#     s_dept_mean[i, 8] = mean(InstEval[InstEval$s == i & InstEval$dept == 8, 'y'])
#     s_dept_mean[i, 9] = mean(InstEval[InstEval$s == i & InstEval$dept == 9, 'y'])
#     s_dept_mean[i, 10] = mean(InstEval[InstEval$s == i & InstEval$dept == 10, 'y'])
#     s_dept_mean[i, 11] = mean(InstEval[InstEval$s == i & InstEval$dept == 11, 'y'])
#     s_dept_mean[i, 12] = mean(InstEval[InstEval$s == i & InstEval$dept == 12, 'y'])
#     s_dept_mean[i, 13] = mean(InstEval[InstEval$s == i & InstEval$dept == 13, 'y'])
#     s_dept_mean[i, 14] = mean(InstEval[InstEval$s == i & InstEval$dept == 14, 'y'])
#     s_dept_mean[i, 15] = mean(InstEval[InstEval$s == i & InstEval$dept == 15, 'y'])
# }

# s_dept <- c()
# for (i in 1:length(InstEval$s)){
#     if (InstEval[i, 'dept'] == 1){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 1])
#     }
#     if (InstEval[i, 'dept'] == 2){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 2])
#     }
#     if (InstEval[i, 'dept'] == 3){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 3])
#     }
#     if (InstEval[i, 'dept'] == 4){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 4])
#     }
#     if (InstEval[i, 'dept'] == 5){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 5])
#     }
#     if (InstEval[i, 'dept'] == 6){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 6])
#     }
#     if (InstEval[i, 'dept'] == 7){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 7])
#     }
#     if (InstEval[i, 'dept'] == 8){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 8])
#     }
#     if (InstEval[i, 'dept'] == 9){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 9])
#     }
#     if (InstEval[i, 'dept'] == 10){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 10])
#     }
#     if (InstEval[i, 'dept'] == 11){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 11])
#     }
#     if (InstEval[i, 'dept'] == 12){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 12])
#     }
#     if (InstEval[i, 'dept'] == 13){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 13])
#     }
#     if (InstEval[i, 'dept'] == 14){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 14])
#     }
#     if (InstEval[i, 'dept'] == 15){
#         s_dept <- c(s_dept, s_dept_mean[InstEval[i, 's'], 15])
#     }
# }

# InstEval$s_dept <- s_dept



# s_dept_service_mean <- matrix(, nrow = length(unique(InstEval$s)), ncol = 15)
# for (i in 1:length(unique(InstEval$s))){
#     s_dept_service_mean[i, 1] = mean(InstEval[InstEval$s == i & InstEval$dept == 1 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 2] = mean(InstEval[InstEval$s == i & InstEval$dept == 2 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 3] = mean(InstEval[InstEval$s == i & InstEval$dept == 3 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 4] = mean(InstEval[InstEval$s == i & InstEval$dept == 4 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 5] = mean(InstEval[InstEval$s == i & InstEval$dept == 5 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 6] = mean(InstEval[InstEval$s == i & InstEval$dept == 6 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 7] = mean(InstEval[InstEval$s == i & InstEval$dept == 7 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 8] = mean(InstEval[InstEval$s == i & InstEval$dept == 8 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 9] = mean(InstEval[InstEval$s == i & InstEval$dept == 9 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 10] = mean(InstEval[InstEval$s == i & InstEval$dept == 10 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 11] = mean(InstEval[InstEval$s == i & InstEval$dept == 11 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 12] = mean(InstEval[InstEval$s == i & InstEval$dept == 12 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 13] = mean(InstEval[InstEval$s == i & InstEval$dept == 13 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 14] = mean(InstEval[InstEval$s == i & InstEval$dept == 14 & InstEval$service == 1, 'y'])
#     s_dept_service_mean[i, 15] = mean(InstEval[InstEval$s == i & InstEval$dept == 15 & InstEval$service == 1, 'y'])
# }
# s_dept_notservice_mean <- matrix(, nrow = length(unique(InstEval$s)), ncol = 15)
# for (i in 1:length(unique(InstEval$s))){
#     s_dept_notservice_mean[i, 1] = mean(InstEval[InstEval$s == i & InstEval$dept == 1 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 2] = mean(InstEval[InstEval$s == i & InstEval$dept == 2 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 3] = mean(InstEval[InstEval$s == i & InstEval$dept == 3 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 4] = mean(InstEval[InstEval$s == i & InstEval$dept == 4 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 5] = mean(InstEval[InstEval$s == i & InstEval$dept == 5 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 6] = mean(InstEval[InstEval$s == i & InstEval$dept == 6 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 7] = mean(InstEval[InstEval$s == i & InstEval$dept == 7 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 8] = mean(InstEval[InstEval$s == i & InstEval$dept == 8 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 9] = mean(InstEval[InstEval$s == i & InstEval$dept == 9 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 10] = mean(InstEval[InstEval$s == i & InstEval$dept == 10 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 11] = mean(InstEval[InstEval$s == i & InstEval$dept == 11 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 12] = mean(InstEval[InstEval$s == i & InstEval$dept == 12 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 13] = mean(InstEval[InstEval$s == i & InstEval$dept == 13 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 14] = mean(InstEval[InstEval$s == i & InstEval$dept == 14 & InstEval$service == 0, 'y'])
#     s_dept_notservice_mean[i, 15] = mean(InstEval[InstEval$s == i & InstEval$dept == 15 & InstEval$service == 0, 'y'])
# }

# s_dept_service <- c()
# for (i in 1:length(InstEval$s)){
#     if (InstEval[i, 'service'] == 1){
#         if (InstEval[i, 'dept'] == 1){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 1])
#         }
#         if (InstEval[i, 'dept'] == 2){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 2])
#         }
#         if (InstEval[i, 'dept'] == 3){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 3])
#         }
#         if (InstEval[i, 'dept'] == 4){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 4])
#         }
#         if (InstEval[i, 'dept'] == 5){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 5])
#         }
#         if (InstEval[i, 'dept'] == 6){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 6])
#         }
#         if (InstEval[i, 'dept'] == 7){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 7])
#         }
#         if (InstEval[i, 'dept'] == 8){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 8])
#         }
#         if (InstEval[i, 'dept'] == 9){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 9])
#         }
#         if (InstEval[i, 'dept'] == 10){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 10])
#         }
#         if (InstEval[i, 'dept'] == 11){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 11])
#         }
#         if (InstEval[i, 'dept'] == 12){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 12])
#         }
#         if (InstEval[i, 'dept'] == 13){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 13])
#         }
#         if (InstEval[i, 'dept'] == 14){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 14])
#         }
#         if (InstEval[i, 'dept'] == 15){
#             s_dept_service <- c(s_dept_service, s_dept_service_mean[InstEval[i, 's'], 15])
#         } 
#     } else {
#         if (InstEval[i, 'dept'] == 1){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 1])
#         }
#         if (InstEval[i, 'dept'] == 2){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 2])
#         }
#         if (InstEval[i, 'dept'] == 3){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 3])
#         }
#         if (InstEval[i, 'dept'] == 4){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 4])
#         }
#         if (InstEval[i, 'dept'] == 5){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 5])
#         }
#         if (InstEval[i, 'dept'] == 6){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 6])
#         }
#         if (InstEval[i, 'dept'] == 7){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 7])
#         }
#         if (InstEval[i, 'dept'] == 8){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 8])
#         }
#         if (InstEval[i, 'dept'] == 9){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 9])
#         }
#         if (InstEval[i, 'dept'] == 10){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 10])
#         }
#         if (InstEval[i, 'dept'] == 11){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 11])
#         }
#         if (InstEval[i, 'dept'] == 12){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 12])
#         }
#         if (InstEval[i, 'dept'] == 13){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 13])
#         }
#         if (InstEval[i, 'dept'] == 14){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 14])
#         }
#         if (InstEval[i, 'dept'] == 15){
#             s_dept_service <- c(s_dept_service, s_dept_notservice_mean[InstEval[i, 's'], 15])
#         }
#     }
# }
# InstEval$s_dept_service <- s_dept_service
# save(InstEval, file = 'data/InstEval.RData')


# Test Model Accuracy
cat("Test Accuracy:", replicMeans(100, "qeLin(InstEval[,c('y', 's_lectage', 'd_studage', 's_dept', 's_dept_service')], 'y')$testAcc"))
cat("Base Accuracy:", replicMeans(1, "qeLin(InstEval[,c('y', 's_lectage', 'd_studage', 's_dept', 's_dept_service')], 'y')$baseAcc"))