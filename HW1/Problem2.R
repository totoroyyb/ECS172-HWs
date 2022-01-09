library(ggplot2)

get_raw_name <- function(movie_names) {
    # Remove anything inside brackets (including brackets).
    temp <- gsub("\\(.*\\)", "", movie_names)

    # Remove punctuations.
    # Any abbrev with ' is counted as one word.
    result <- gsub("[[:punct:]]+", "", temp)

    return(trimws(result))
}

prep_data <- function(data_folder = "ml-100k") {
    movies_df <- read.table(
        file.path(data_folder, "u.item"),
        header = FALSE,
        sep = "|",
        quote = ""
    )
    movie_data <- movies_df[, 2:3]
    colnames(movie_data) <- c("name", "release_date")

    movie_data$name <- get_raw_name(movie_data$name)
    movie_data$name_len <- lapply(
        strsplit(movie_data$name, " "),
        length
    )
    movie_data$release_year <- lapply(
        movie_data$release_date,
        function(date) substr(date, nchar(date) - 3, nchar(date))
    )
    movie_data$release_year <- as.integer(movie_data$release_year)
    movie_data$name_len <- as.integer(movie_data$name_len)
    movie_data
}

movie_data <- prep_data()
name_len_by_year <- as.data.frame(tapply(
    movie_data$name_len,
    movie_data$release_year,
    mean
))
name_len_by_year <- cbind(
    name_len_by_year,
    rownames(name_len_by_year)
)
colnames(name_len_by_year) <- c("name_len", "year")
name_len_by_year$year <- as.integer(name_len_by_year$year)

p <- ggplot(name_len_by_year, aes(year, name_len)) +
    geom_bar(stat = "identity") +
    labs(
        x = "Release Year",
        y = "Mean Title Length (by word)",
        title = "Mean Title Length over Time"
    )

print(p)
