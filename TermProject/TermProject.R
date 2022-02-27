require(rectools)
require(qeML)
require(ggplot2)
load("./data/ml100kpluscovs.RData")

# Create The Fake Rating Matrix
model <- qeLin(ml100kpluscovs[, c("rating", "userMean", "itemMean")], "rating")
user_mean <- tapply(ml100kpluscovs$userMean, ml100kpluscovs$user, mean)
item_mean <- tapply(ml100kpluscovs$itemMean, ml100kpluscovs$item, mean)
user_mean_coef <- matrix(rep(user_mean, each = length(item_mean)),
ncol = length(item_mean), byrow = TRUE) * model$coefficients["userMean"]
item_mean_coef <- matrix(rep(item_mean, length(user_mean)),
nrow = length(user_mean)) * model$coefficients["itemMean"]
rating_matrix <- user_mean_coef + item_mean_coef +
model$coefficients["(Intercept)"]
for (index in seq_len(length(ml100kpluscovs$user))) {
    rating_matrix[ml100kpluscovs$user[index], ml100kpluscovs$item[index]] <-
    ml100kpluscovs$rating[index]
}
