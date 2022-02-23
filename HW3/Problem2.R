library(data.table)
prep_data <- function(data_dir = "./data/") {
    url <- "http://www2.informatik.uni-freiburg.de/~cziegler/BX/BX-CSV-Dump.zip"
    temp <- tempfile()
    download.file(url, dest = temp)
    unzip(temp, exdir = data_dir)
}


get_dataF <- function() {
  Users <- read_delim("data/BX-Users.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE)
  Books <- read_delim("data/BX-Books.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE)
  Ratings <- read_delim("data/BX-Book-Ratings.csv", 
                         delim = ";", escape_double = FALSE, trim_ws = TRUE)
  save(Books, Ratings, Users, file = './data/Hwk3.RData')
}

# prep_data()
# get_dataF()
User_ID = as.matrix(unique(Ratings$`User-ID`))
Book_ID =  as.matrix(unique(Ratings$`ISBN`))

Ratings_matrix <- matrix(Ratings$`Book-Rating`, nrow = length(unique(Ratings$`User-ID`)), byrow = TRUE)
