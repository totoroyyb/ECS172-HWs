# loading in TA's script

load("Hwk1.RData")

plotDensities <- function(inputDF, xName, grpName) {
    library(ggplot2)

    inputDF[, grpName] <- as.factor(inputDF[, grpName])

    p <- ggplot(inputDF, aes_string(x = xName, color = grpName)) +
        geom_density() +
        labs(
            x = xName,
            y = "Density",
            title = paste("Density Plot of", xName, "for Different", grpName)
        )

    print(p)
    p
}

get_mean_rating <- function(item) {
    sub_df <- data_for_process[data_for_process$item == 1, ]
    mean(sub_df$rating)
    ret <- sub_df[1,]
    ret$meanRating <- mean(sub_df$rating)
    ret <- ret[c("item", genre_col_names, "meanRating")]
    return(ret)
}
get_mean_rating(2)

prep_data <- function(allow_multiple_genres = FALSE) {
    num_genres <- 19
    genre_col_names <- paste0(rep("G", num_genres), 1:num_genres)
    preinclude_cols <- c("user", "item", "rating")
    data_for_process <- ml100kpluscovs[, c(preinclude_cols, genre_col_names)]
    
    get_mean_rating <- function(movie_num) {
        sub_df <- data_for_process[data_for_process$item == movie_num, ]
        mean(sub_df$rating)
        ret <- sub_df[1,]
        ret$meanRating <- mean(sub_df$rating)
        ret <- ret[c("item", genre_col_names, "meanRating")]
        return(ret)
    }

    mean_df <- data.frame()
    for (i in unique(data_for_process$item)) {
        mean_df <- rbind(mean_df, get_mean_rating(i))
    }

    convert_genre <- function(r) {
        genre_name <- sample(names(r)[r == 1], 1)
        genre_index <- substr(genre_name, 2, nchar(genre_name))
        as.integer(genre_index)
    }
    

    converted_genres <- apply(
        mean_df[, genre_col_names],
        1,
        convert_genre
    )
    cbind(mean_df, genre = converted_genres)
}

genre_df <- prep_data()
print("Only plotting first 8 genres for clarity...")
genre_df <- genre_df[genre_df["genre"] <= 8, ]
plotDensities(genre_df, "meanRating", "genre")
