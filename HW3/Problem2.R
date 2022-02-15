prep_data <- function(data_dir = "./data/") {
    url <- "http://www2.informatik.uni-freiburg.de/~cziegler/BX/BX-CSV-Dump.zip"
    temp <- tempfile()
    download.file(url, dest = temp)
    unzip(temp, exdir = data_dir)
}

# prep_data()


