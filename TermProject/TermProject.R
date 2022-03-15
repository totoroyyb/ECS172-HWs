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
    rownames(rating_matrix_subset) <- orig_row_names[1:n]
    colnames(rating_matrix_subset) <- orig_col_names[1:m]

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
generate_graph_for_fixed_d <- function(d, mape_run_time_m_n,
model, data_source) {
    mape_m_n <- mape_run_time_m_n[[1]]
    run_time_m_n <- mape_run_time_m_n[[2]]

    data_frame_m_n <- data.frame(matrix(nrow = length(n) * length(m),
    ncol = 4))
    colnames(data_frame_m_n) <- c("n", "m", "mape", "run_time")
    data_frame_m_n$n <- as.factor(array(matrix(rep(n, each = length(m)),
    ncol = length(m), byrow = TRUE)))
    data_frame_m_n$m <- as.factor(rep(m, each = length(n)))
    mape <- c()
    for (i in seq_len(length(m))) {
        mape <- c(mape, mape_m_n[i, ])
    }
    data_frame_m_n$mape <- mape
    run_time <- c()
    for (i in seq_len(length(m))) {
        run_time <- c(run_time, run_time_m_n[i, ])
    }
    data_frame_m_n$run_time <- run_time

    plot <- ggplot(data = data_frame_m_n, aes(x = n, y = mape, group = m,
    color = m, fill = m, shape = m)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("MAPE vs Number of Users for Fixed d (", model, ")"),
            subtitle = paste0(
                    " where d = ",
                    d
                ),
            x = "Number of Users",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/d-", d, " (mape)", ".png"), plot)

    plot <- ggplot(data = data_frame_m_n, aes(x = n, y = run_time, group = m,
    color = m, fill = m, shape = m)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("Run Time vs Number of Users for Fixed d (", model, ")"),
            subtitle = paste0(
                    " where d = ",
                    d
                ),
            x = "Number of Users",
            y = "Run Time (in secs)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/d-", d, " (run time)", ".png"), plot)
}

# Generate Graph For Fixed n
generate_graph_for_fixed_n <- function(n, mape_run_time_d_m,
model, data_source) {
    mape_d_m <- mape_run_time_d_m[[1]]
    run_time_d_m <- mape_run_time_d_m[[2]]

    data_frame_d_m <- data.frame(matrix(nrow = length(m) * length(d),
    ncol = 4))
    colnames(data_frame_d_m) <- c("m", "d", "mape", "run_time")
    data_frame_d_m$m <- as.factor(array(matrix(rep(m, each = length(d)),
    ncol = length(d), byrow = TRUE)))
    data_frame_d_m$d <- as.factor(rep(d, each = length(m)))
    mape <- c()
    for (i in seq_len(length(d))) {
        mape <- c(mape, mape_d_m[i, ])
    }
    data_frame_d_m$mape <- mape
    run_time <- c()
    for (i in seq_len(length(d))) {
        run_time <- c(run_time, run_time_d_m[i, ])
    }
    data_frame_d_m$run_time <- run_time

    plot <- ggplot(data = data_frame_d_m, aes(x = m, y = mape, group = d,
    color = d, fill = d, shape = d)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("MAPE vs Number of Items for Fixed Users (", model, ")"),
            subtitle = paste0(
                    " where n = ",
                    n
                ),
            x = "Number of Items",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/n-", n, " (mape)", ".png"), plot)

    plot <- ggplot(data = data_frame_d_m, aes(x = m, y = run_time, group = d,
    color = d, fill = d, shape = d)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("Run Time vs Number of Items for Fixed Users (", model, ")"),
            subtitle = paste0(
                    " where n = ",
                    n
                ),
            x = "Number of Items",
            y = "Run Time (in secs)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/n-", n, " (run time)", ".png"), plot)
}

# Generate Graph For Fixed m
generate_graph_for_fixed_m <- function(m, mape_run_time_n_d,
model, data_source) {
    mape_n_d <- mape_run_time_n_d[[1]]
    run_time_n_d <- mape_run_time_n_d[[2]]

    data_frame_n_d <- data.frame(matrix(nrow = length(d) * length(n),
    ncol = 4))
    colnames(data_frame_n_d) <- c("d", "n", "mape", "run_time")
    data_frame_n_d$d <- as.factor(array(matrix(rep(d, each = length(n)),
    ncol = length(n), byrow = TRUE)))
    data_frame_n_d$n <- as.factor(rep(n, each = length(d)))
    mape <- c()
    for (i in seq_len(length(n))) {
        mape <- c(mape, mape_n_d[i, ])
    }
    data_frame_n_d$mape <- mape
    run_time <- c()
    for (i in seq_len(length(n))) {
        run_time <- c(run_time, run_time_n_d[i, ])
    }
    data_frame_n_d$run_time <- run_time

    plot <- ggplot(data = data_frame_n_d, aes(x = d, y = mape, group = n,
    color = n, fill = n, shape = n)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("MAPE vs Proportion of Non-NA Values for Fixed Items (", model, ")"),
            subtitle = paste0(
                    " where m = ",
                    m
                ),
            x = "Proportion of Non-NA Values",
            y = "MAPE (Mean Absolute Percentage Error)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/m-", m, " (mape)", ".png"), plot)

    plot <- ggplot(data = data_frame_n_d, aes(x = d, y = run_time, group = n,
    color = n, fill = n, shape = n)) +
        geom_line() +
        geom_point(size = 3) +
        labs(
            title = paste0("Run Time vs Proportion of Non-NA Values for Fixed Items (", model, ")"),
            subtitle = paste0(
                    " where m = ",
                    m
                ),
            x = "Proportion of Non-NA Values",
            y = "Run Time (in secs)",
            caption = paste0("data source: ", data_source)
        ) +
        theme(plot.title = element_text(hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5))

    save_path <- paste0("./results/", data_source, "/", model)
    ggsave(paste0(save_path, "/m-", m, " (run time)", ".png"), plot)
}

# Calculate MAPE For Fixed d
calculate_mape_fixed_d <- function(d, model) {
    mape_m_n <- matrix(, nrow = length(m), ncol = length(n))
    run_time_m_n <- matrix(, nrow = length(m), ncol = length(n))

    for (m_choice in m) {
        mape_n <- c()
        run_time_n <- c()

        for (n_choice in n) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n_choice, m_choice, d, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            data_frame$userID <- as.numeric(data_frame$userID)
            data_frame$itemID <- as.numeric(data_frame$itemID)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                start_time <- Sys.time()
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                start_time <- Sys.time()
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }

            mape_n <- c(mape_n, mape)
            run_time_n <- c(run_time_n, run_time)
        }
        mape_m_n[match(m_choice, m), ] <- mape_n
        run_time_m_n[match(m_choice, m), ] <- run_time_n
    }

    return(list(mape_m_n, run_time_m_n))
}

# Calculate MAPE For Fixed n
calculate_mape_fixed_n <- function(n, model) {
    mape_d_m <- matrix(, nrow = length(d), ncol = length(m))
    run_time_d_m <- matrix(, nrow = length(d), ncol = length(m))

    for (d_choice in d) {
        mape_m <- c()
        run_time_m <- c()

        for (m_choice in m) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n, m_choice, d_choice, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            data_frame$userID <- as.numeric(data_frame$userID)
            data_frame$itemID <- as.numeric(data_frame$itemID)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                start_time <- Sys.time()
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                start_time <- Sys.time()
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }
            mape_m <- c(mape_m, mape)
            run_time_m <- c(run_time_m, run_time)
        }
        mape_d_m[match(d_choice, d), ] <- mape_m
        run_time_d_m[match(d_choice, d), ] <- run_time_m
    }

    return(list(mape_d_m, run_time_d_m))
}

# Calculate MAPE For Fixed m
calculate_mape_fixed_m <- function(m, model) {
    mape_n_d <- matrix(, nrow = length(n), ncol = length(d))
    run_time_n_d <- matrix(, nrow = length(n), ncol = length(d))

    for (n_choice in n) {
        mape_d <- c()
        run_time_d <- c()

        for (d_choice in d) {
            rating_matrix_subset <- generate_rating_matrix_subset(
                n_choice, m, d_choice, rating_matrix
            )

            data_frame <- toUserItemRatings(rating_matrix_subset)
            data_frame$userID <- as.numeric(data_frame$userID)
            data_frame$itemID <- as.numeric(data_frame$itemID)
            training_test_sets <- generate_training_test_sets(data_frame)

            if (model == "Linear Model") {
                training_set <- generate_usermean_itemmean(
                    training_test_sets[[1]])
                start_time <- Sys.time()
                mape <- calculate_mape_linear_model(training_set,
                training_test_sets[[2]])
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }

            if (model == "MF (Reco)") {
                training_test_files <- generate_training_test_files(
                training_test_sets)
                start_time <- Sys.time()
                mape <- calculate_mape_mf_reco(training_test_files[[1]],
                training_test_files[[2]], training_test_sets[[2]]$ratings)
                end_time <- Sys.time()
                run_time <- end_time - start_time
            }

            mape_d <- c(mape_d, mape)
            run_time_d <- c(run_time_d, run_time)
        }
        mape_n_d[match(n_choice, n), ] <- mape_d
        run_time_n_d[match(n_choice, n), ] <- run_time_d
    }

    return(list(mape_n_d, run_time_n_d))
}

# Generate Graph
generate_graph <- function(model, data_source) {
    for (d_choice in d) {
        mape_run_time_m_n <- calculate_mape_fixed_d(d_choice, model)
        generate_graph_for_fixed_d(d_choice, mape_run_time_m_n,
        model, data_source)
    }

    for (n_choice in n) {
        mape_run_time_d_m <- calculate_mape_fixed_n(n_choice, model)
        generate_graph_for_fixed_n(n_choice, mape_run_time_d_m,
        model, data_source)
    }

    for (m_choice in m) {
        mape_run_time_n_d <- calculate_mape_fixed_m(m_choice, model)
        generate_graph_for_fixed_m(m_choice, mape_run_time_n_d,
        model, data_source)
    }
}

# Main
set.seed(123)
data_sources <- list("MovieLens", "InstEval")
models <- list("Linear Model", "MF (Reco)")
dir.create("./results", showWarnings = FALSE)

for (data_source in data_sources) {
    dir.create(paste0("./results/", data_source), showWarnings = FALSE)

    if (data_source == "MovieLens") {
        data_frame <- ml100kpluscovs
    }
    if (data_source == "InstEval") {
        data_frame <- InstEval[1:30000, ]
        colnames(data_frame)[match("s", colnames(data_frame))] <- "user"
        colnames(data_frame)[match("d", colnames(data_frame))] <- "item"
        colnames(data_frame)[match("sy", colnames(data_frame))] <- "userMean"
        colnames(data_frame)[match("dy", colnames(data_frame))] <- "itemMean"
        colnames(data_frame)[match("y", colnames(data_frame))] <- "rating"
    }

    rating_matrix_info <- generate_fake_rating_matrix(data_frame)
    rating_matrix <- rating_matrix_info[[1]]
    user_mean <- rating_matrix_info[[2]]
    item_mean <- rating_matrix_info[[3]]

    if (data_source == "MovieLens") {
        n <- c(150, 300, 450, 600, 750, length(user_mean))
        m <- c(300, 600, 900, 1200, length(item_mean))
        d <- c(20, 40, 60, 80, 100)
    }
    if (data_source == "InstEval") {
        n <- c(200, 400, 600, 800, 1000, length(user_mean))
        m <- c(200, 400, 600, 800, 1000, length(item_mean))
        d <- c(20, 40, 60, 80, 100)
    }

    for (model in models) {
        dir.create(paste0("./results/", data_source, "/", model),
        showWarnings = FALSE)
        generate_graph(model, data_source)
    }
}

