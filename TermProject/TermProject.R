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
set.seed(123)
n <- c(150, 300, 450, 600, 750, length(user_mean))
m <- c(300, 600, 900, 1200, length(item_mean))
d <- c(20, 40, 60, 80, 100)

# Generate the Required Subset Rating Matrix
generate_rating_matrix_subset <- function(n, m, d, rating_matrix) {
    rating_matrix_subset <- rating_matrix[1:n, 1:m]

    rating_matrix_subset <- array(rating_matrix_subset)
    random_sequence <- sample.int(n * m, floor(n * m * (100 - d) / 100))
    rating_matrix_subset[random_sequence] <- NA

    rating_matrix_subset <- matrix(rating_matrix_subset, nrow = n, ncol = m)

    rating_matrix_subset
}

# Generate Training and Test Sets
generate_training_test_sets <- function(data_frame) {
    test_proportion <- 0.3
    test_index <- sample.int(dim(data_frame)[1],
    floor(dim(data_frame)[1] * test_proportion))

    training_set <- data_frame[-test_index, ]
    test_set <- data_frame[test_index, ]

    return(list(training_set, test_set))
}

# Generate userMean and itemMean Columns
generate_usermean_itemmean <- function(data_frame) {
    user_mean <- tapply(data_frame$ratings, data_frame$userID, mean)
    item_mean <- tapply(data_frame$ratings, data_frame$itemID, mean)

    users <- sort(unique(data_frame$userID))
    items <- sort(unique(data_frame$itemID))

    data_frame$user_mean <- user_mean[match(data_frame$userID, users)]
    data_frame$item_mean <- item_mean[match(data_frame$itemID, items)]

    return(data_frame)
}

# Calculate MAPE Using Linear Model
calculate_mape_linear_model <- function(data_frame_training, data_frame_test) {
    model <- qeLin(data_frame_training[,
    c("ratings", "user_mean", "item_mean")], "ratings")
    coefficients <- model$coefficients

    user_mean <- tapply(data_frame_training$ratings,
    data_frame_training$userID, mean)
    item_mean <- tapply(data_frame_training$ratings,
    data_frame_training$itemID, mean)

    users <- sort(unique(data_frame_training$userID))
    items <- sort(unique(data_frame_training$itemID))

    unseen_users <- get_infirst_notsecond(unique(data_frame_test$userID), users)
    unseen_items <- get_infirst_notsecond(unique(data_frame_test$itemID), items)

    users <- c(users, unseen_users)
    items <- c(items, unseen_items)

    user_mean <- c(user_mean, mean(user_mean))
    item_mean <- c(item_mean, mean(item_mean))

    data_frame_test$user_mean <- user_mean[match(data_frame_test$userID, users)]
    data_frame_test$item_mean <- item_mean[match(data_frame_test$itemID, items)]

    num_predictions <- dim(data_frame_test)[1]
    predictions <- rep(coefficients["(Intercept)"], each = num_predictions) +
    rep(coefficients["user_mean"], each = num_predictions) *
    data_frame_test$user_mean +
    rep(coefficients["item_mean"], each = num_predictions) *
    data_frame_test$item_mean

    actual_ratings <- data_frame_test$ratings
    mape <- mean(abs((actual_ratings - predictions) / actual_ratings))

    return(mape)
}

# Get Elements In The First Vector But Not The Second Vector
get_infirst_notsecond <- function(first_vector, second_vector) {
    unseen_element <- c()

    for (element in first_vector) {
        if (!(element %in% second_vector)) {
            unseen_element <- c(unseen_element, element)
        }
    }

    return(unseen_element)
}

gen_variable_param <- function(varies1, varies2, fix_val) {
    result <- list()
    for (i in 1:length(varies1)) {
        for (j in 1:length(varies2)) {
            result[[length(result) + 1]] <- c(varies1[i], varies2[j], fix_val)
        }
    }
    result
}

run <- function(n, m, d, rating_matrix) {
    rating_matrix_subset <- generate_rating_matrix_subset(
        n, m, d, rating_matrix
    )
    data_frame <- toUserItemRatings(rating_matrix_subset)
    training_test_sets <- generate_training_test_sets(data_frame)
    training_set <- generate_usermean_itemmean(training_test_sets[[1]])
    mape <- calculate_mape_linear_model(training_set, training_test_sets[[2]])
    mape
}

run_with_varied_n <- function(m, d, rating_matrix, source_name = "Unnamed") {
    result <- c()
    for (curr_n in n) {
        result <- c(result, run(curr_n, m, d, rating_matrix))
    }

    result_df <- data.frame(MAPE = result, n = n)
    result_df$n <- as.factor(result_df$n)
    p <- ggplot(result_df, aes(n, MAPE)) +
            geom_bar(stat = "identity") +
            labs(
                title = "Changes of MAPE for different n values",
                subtitle = paste0(
                    "where m = ",
                    m,
                    " and d = ",
                    d
                ),
                caption = paste0("Data Source: ", source_name)
            )
    ggsave(paste0("./results/", "m-", m, "-d-", d, ".png"), p)
    p
}

run_with_varied_m <- function(n, d, rating_matrix, source_name = "Unnamed") {
    result <- c()
    for (curr_m in m) {
        result <- c(result, run(n, curr_m, d, rating_matrix))
    }

    result_df <- data.frame(MAPE = result, m = m)
    result_df$m <- as.factor(result_df$m)
    p <- ggplot(result_df, aes(m, MAPE)) +
            geom_bar(stat = "identity") +
            labs(
                title = "Changes of MAPE for different m values",
                subtitle = paste0(
                    "where n = ",
                    n,
                    " and d = ",
                    d
                ),
                caption = paste0("Data Source: ", source_name)
            )
    p
}

run_with_varied_d <- function(n, m, rating_matrix, source_name = "Unnamed") {
    result <- c()
    for (curr_d in d) {
        result <- c(result, run(n, m, curr_d, rating_matrix))
    }

    result_df <- data.frame(MAPE = result, d = d)
    result_df$d <- as.factor(result_df$d)
    p <- ggplot(result_df, aes(d, MAPE)) +
            geom_bar(stat = "identity") +
            labs(
                title = "Changes of MAPE for different m values",
                subtitle = paste0(
                    "where n = ",
                    n,
                    " and m = ",
                    m
                ),
                caption = paste0("Data Source: ", source_name)
            )
    p
}

run_with_fixed_md <- function(rating_matrix, source_name) {
    combs <- expand.grid(m = m, d = d)
    plots <- c()
    for (i in 1:nrow(combs)) {
        plots <- c(
            plots,
            run_with_varied_n(
                combs$m[[i]], combs$d[[i]], rating_matrix, source_name
            )
        )
    }
    plots
}

# p <- run_with_varied_n(m[3], d[3], rating_matrix)
plots <- run_with_fixed_md(rating_matrix, "test")


# rating_matrix_subset <- generate_rating_matrix_subset(n[3],
# m[3], d[3], rating_matrix)
# data_frame <- toUserItemRatings(rating_matrix_subset)
# training_test_sets <- generate_training_test_sets(data_frame)
# training_set <- generate_usermean_itemmean(training_test_sets[[1]])
# mape <- calculate_mape_linear_model(training_set, training_test_sets[[2]])
# mape <- calculate_mape_linear_model(training_set, training_test_sets[[2]])
