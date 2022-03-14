require(rectools)
require(qeML)
require(ggplot2)
library(recosystem)
load("./data/ml100kpluscovs.RData")
load("./data/InstEval.RData")

# Create The Fake Rating Matrix By Linear Model
generate_fake_rating_matrix <- function(data_frame) {
    user_mean <- tapply(data_frame$userMean, data_frame$user, mean)
    item_mean <- tapply(data_frame$itemMean, data_frame$item, mean)

    model <- qeLin(data_frame[, c("rating", "userMean", "itemMean")],
    "rating")
    user_mean_coef <- matrix(rep(user_mean, each = length(item_mean)),
    ncol = length(item_mean), byrow = TRUE) * model$coefficients["userMean"]
    item_mean_coef <- t(matrix(rep(item_mean, each = length(user_mean)),
    ncol = length(user_mean), byrow = TRUE)) * model$coefficients["itemMean"]

    rating_matrix <- user_mean_coef + item_mean_coef +
    model$coefficients["(Intercept)"]

    colnames(rating_matrix) <- seq_len(length(item_mean))
    rownames(rating_matrix) <- seq_len(length(user_mean))

    for (index in seq_len(length(data_frame$user))) {
        rating_matrix[data_frame$user[index], data_frame$item[index]] <-
        data_frame$rating[index]
    }

    return(list(rating_matrix, user_mean, item_mean))
}

# Generate the Required Subset Rating Matrix
generate_rating_matrix_subset <- function(n, m, d, rating_matrix) {
    orig_row_names <- rownames(rating_matrix)
    orig_col_names <- colnames(rating_matrix)
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

# Generate Training and Test Files For Matrix Factorization
generate_training_test_files <- function(training_test_sets) {
    write.table(training_test_sets[[1]], "train.txt",
    row.names = FALSE, col.names = FALSE)
    write.table(training_test_sets[[2]][, -3], "test.txt",
    row.names = FALSE, col.names = FALSE)

    return(list("train.txt", "test.txt"))
}

# Calculate MAPE Using Matrix Factorization (Recosystem)
calculate_mape_mf_reco <- function(train_file, test_file, actual_ratings) {
    train_set <- data_file(train_file)
    test_set <- data_file(test_file)

    r <- Reco()
    opts <- r$tune(train_set, opts = list(dim = c(10, 20, 30),
    lrate = c(0.1, 0.2), costp_l1 = 0, costq_l1 = 0, nthread = 1, niter = 10))
    r$train(train_set, opts = c(opts$min, nthread = 1, niter = 10))

    pred_file <- tempfile()
    r$predict(test_set, out_file(pred_file))

    file.remove(train_file)
    file.remove(test_file)

    return(mean(abs((scan(pred_file) - actual_ratings) / actual_ratings)))
}

# Generate Graph For Fixed d
generate_graph_for_fixed_d <- function(d, mape_m_n, model, data_source) {
    data_frame_m_n <- data.frame(matrix(nrow = length(n) * length(m),
    ncol = 3))
    colnames(data_frame_m_n) <- c("n", "m", "mape")
    data_frame_m_n$n <- as.factor(array(matrix(rep(n, each = length(m)),
    ncol = length(m), byrow = TRUE)))
    data_frame_m_n$m <- as.factor(rep(m, each = length(n)))
    mape <- c()
    for (i in seq_len(length(m))) {
        mape <- c(mape, mape_m_n[i, ])
    }
    data_frame_m_n$mape <- mape

    plot <- ggplot(data = data_frame_m_n, aes(x = n, y = mape, group = m,
    color = m)) +
        geom_line() +
        geom_point(
            shape = 21, color = "black", fill = "#69b3a2", size = 3
        ) +
        scale_color_brewer(palette = "Paired") +
        labs(
            title = paste0("MAPE vs Number of Users for Fixed d (", model, ")"),
            subtitle = paste0(
                    " where d = ",
                    d
                ),
            x = "Number of Users",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        )

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/d-", d, ".png"), plot)
}

# Generate Graph For Fixed n
generate_graph_for_fixed_n <- function(n, mape_d_m, model, data_source) {
    data_frame_d_m <- data.frame(matrix(nrow = length(m) * length(d),
    ncol = 3))
    colnames(data_frame_d_m) <- c("m", "d", "mape")
    data_frame_d_m$m <- as.factor(array(matrix(rep(m, each = length(d)),
    ncol = length(d), byrow = TRUE)))
    data_frame_d_m$d <- as.factor(rep(d, each = length(m)))
    mape <- c()
    for (i in seq_len(length(d))) {
        mape <- c(mape, mape_d_m[i, ])
    }
    data_frame_d_m$mape <- mape

    plot <- ggplot(data = data_frame_d_m, aes(x = m, y = mape, group = d,
    color = d)) +
        geom_line() +
        geom_point(
            shape = 21, color = "black", fill = "#69b3a2", size = 3
        ) +
        scale_color_brewer(palette = "Paired") +
        labs(
            title = paste0("MAPE vs Number of Items for Fixed Users
            (", model, ")"),
            subtitle = paste0(
                    " where n = ",
                    n
                ),
            x = "Number of Items",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        )

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/n-", n, ".png"), plot)
}

# Generate Graph For Fixed m
generate_graph_for_fixed_m <- function(m, mape_n_d, model, data_source) {
    data_frame_n_d <- data.frame(matrix(nrow = length(d) * length(n),
    ncol = 3))
    colnames(data_frame_n_d) <- c("d", "n", "mape")
    data_frame_n_d$d <- as.factor(array(matrix(rep(d, each = length(n)),
    ncol = length(n), byrow = TRUE)))
    data_frame_n_d$n <- as.factor(rep(n, each = length(d)))
    mape <- c()
    for (i in seq_len(length(n))) {
        mape <- c(mape, mape_n_d[i, ])
    }
    data_frame_n_d$mape <- mape

    plot <- ggplot(data = data_frame_n_d, aes(x = d, y = mape, group = n,
    color = n)) +
        geom_line() +
        geom_point(
            shape = 21, color = "black", fill = "#69b3a2", size = 3
        ) +
        scale_color_brewer(palette = "Paired") +
        labs(
            title = paste0("MAPE vs Proportion of Non-NA Values for Fixed Items
            (", model, ")"),
            subtitle = paste0(
                    " where m = ",
                    m
                ),
            x = "Proportion of Non-NA Values",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        )

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/m-", m, ".png"), plot)
}

# Calculate MAPE For Fixed d
calculate_mape_fixed_d <- function(d, model) {
    mape_m_n <- matrix(, nrow = length(m), ncol = length(n))

    for (m_choice in m) {
        mape_n <- c()

        for (n_choice in n) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n_choice, m_choice, d, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
            }

            mape_n <- c(mape_n, mape)
        }
        mape_m_n[match(m_choice, m), ] <- mape_n
    }

    return(mape_m_n)
}

# Calculate MAPE For Fixed n
calculate_mape_fixed_n <- function(n, model) {
    mape_d_m <- matrix(, nrow = length(d), ncol = length(m))

    for (d_choice in d) {
        mape_m <- c()

        for (m_choice in m) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n, m_choice, d_choice, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
            }
 
            mape_m <- c(mape_m, mape)
        }
        mape_d_m[match(d_choice, d), ] <- mape_m
    }

    return(mape_d_m)
}

# Calculate MAPE For Fixed m
calculate_mape_fixed_m <- function(m, model) {
    mape_n_d <- matrix(, nrow = length(n), ncol = length(d))

    for (n_choice in n) {
        mape_d <- c()

        for (d_choice in d) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n_choice, m, d_choice, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
            }

            mape_d <- c(mape_d, mape)
        }
        mape_n_d[match(n_choice, n), ] <- mape_d
    }

    return(mape_n_d)
}

# Generate Graph
generate_graph <- function(model, data_source) {
    for (d_choice in d) {
        mape_m_n <- calculate_mape_fixed_d(d_choice, model)
        generate_graph_for_fixed_d(d_choice, mape_m_n, model, data_source)
    }

    for (n_choice in n) {
        mape_d_m <- calculate_mape_fixed_n(n_choice, model)
        generate_graph_for_fixed_n(n_choice, mape_d_m, model, data_source)
    }

    for (m_choice in m) {
        mape_n_d <- calculate_mape_fixed_m(m_choice, model)
        generate_graph_for_fixed_m(m_choice, mape_n_d, model, data_source)
    }
}

# Main
generate_graph("Linear Model", "MovieLens")
generate_graph("MF (Reco)", "MovieLens")