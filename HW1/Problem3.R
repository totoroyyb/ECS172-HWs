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

prep_data <- function(allow_multiple_genres = FALSE) {
    num_genres <- 19
    genre_col_names <- paste0(rep("G", num_genres), 1:num_genres)
    preinclude_cols <- c("user", "item", "rating")
    data_for_process <- ml100kpluscovs[, c(preinclude_cols, genre_col_names)]

    convert_genre <- function(r) {
        genre_name <- sample(names(r)[r == 1], 1)
        genre_index <- substr(genre_name, 2, nchar(genre_name))
        as.integer(genre_index)
    }

    converted_genres <- apply(
        data_for_process[, genre_col_names],
        1,
        convert_genre
    )
    cbind(data_for_process, genre = converted_genres)
}

genre_df <- prep_data()
print("Only plotting first 8 genres for clarity...")
genre_df <- genre_df[genre_df["genre"] <= 8, ]
plotDensities(genre_df, "rating", "genre")
