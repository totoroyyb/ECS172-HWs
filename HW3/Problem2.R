library(data.table)
prep_data <- function(data_dir = "./data/") {
    url <- "http://www2.informatik.uni-freiburg.de/~cziegler/BX/BX-CSV-Dump.zip"
    temp <- tempfile()
    download.file(url, dest = temp)
    unzip(temp, exdir = data_dir)
}

options(warn = -1)
Users <- fread('./data/BX-Users.csv', sep=';')
Books<- fread('./data/BX-Books.csv', sep=';')
Books_Ratings <- fread('./data/BX-Book-Ratings.csv', sep=';')
options(warn = 0)
Rating_Matrix <- matrix(, nrow = dim(Users)[1], ncol = dim(Books)[1])

# get_dataF <- function() {
#   Users <- read_delim("data/BX-Users.csv", 
#                          delim = ";", escape_double = FALSE, trim_ws = TRUE)
#   Books <- read_delim("data/BX-Books.csv", 
#                          delim = ";", escape_double = FALSE, trim_ws = TRUE)
#   Ratings <- read_delim("data/BX-Book-Ratings.csv", 
#                          delim = ";", escape_double = FALSE, trim_ws = TRUE)
#   save(Books, Ratings, Users, file = './data/Hwk3.RData')
# }

# prep_data()
# get_dataF()
# User_ID <- as.matrix(unique(Ratings$`User-ID`))
# Book_ID <-  as.matrix(unique(Ratings$`ISBN`))

# Ratings_matrix <- matrix(Ratings$`Book-Rating`, nrow = length(unique(Ratings$`User-ID`)), byrow = TRUE)
