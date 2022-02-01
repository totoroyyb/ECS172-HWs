require(rectools)

#InstEval
getInstEval()

#house_vote
colnames<- c('party', paste0(rep("B", 16), 1:16))
house_vote = read.csv('house-votes-84.data', header = FALSE, col.names = colnames)




#ml100kpluscovs
load('Hwk1.RData')
genre_col_names <- paste0(rep("G", 19), 1:19)
convert_genre <- function(r) {
  genre_name <- sample(names(r)[r == 1], 1)
  genre_index <- substr(genre_name, 2, nchar(genre_name))
  as.integer(genre_index)
}
converted_genres <- apply(
  ml100kpluscovs[, genre_col_names],
  1,
  convert_genre
)



save(ml100kpluscovs, house_vote, InstEval, file = 'Hwk2.RData')
