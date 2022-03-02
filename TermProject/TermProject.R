require(rectools)
require(qeML)
require(ggplot2)
load("./data/ml100kpluscovs.RData")

# Create The Fake Rating Matrix
user_mean <- tapply(ml100kpluscovs$userMean, ml100kpluscovs$user, mean)
item_mean <- tapply(ml100kpluscovs$itemMean, ml100kpluscovs$item, mean)

model <- qeLin(ml100kpluscovs[, c("rating", "userMean", "itemMean")], "rating")
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

# Set Up Choices of n(Number of Users), m(Number of Items), d(non-NA Density)
n <- c(150, 300, 450, 600, 750, length(user_mean))
m <- c(300, 600, 900, 1200, length(item_mean))
d <- c(20, 40, 60, 80, 100)

# Generate the Required Subset Rating Matrix
create_rating_matrix_subset <- function(n, m, d, rating_matrix) {
    rating_matrix_subset <- rating_matrix[1:n, 1:m]
    rating_matrix_subset <- array(t(rating_matrix_subset))
    random_sequence <- sample.int(n * m, floor(n * m * (100 - d) / 100))
    rating_matrix_subset[random_sequence] <- NA
    rating_matrix_subset <- matrix(rating_matrix_subset, nrow = n, ncol = m)
    rating_matrix_subset
}
