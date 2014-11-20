#
#   build.R: build Harvard political contribution data from raw FEC 2000 - 2014 data
#

# directory names
raw_data.path    <- "raw_data"
header.path  <- "data/header"
# data filenames
indiv.fname  <- "itcont.txt"
cm.fname     <- "cm.txt"
cn.fname     <- "cn.txt"

set.headers <- function() {
    ## Read in header files and define global variables
    setwd(header.path)
    indiv.header <- "indiv_header_file.csv"
    cm.header    <- "cm_header_file.csv"
    cn.header    <- "cn_header_file.csv"
    # set global header file frames
    indiv_header <<- read.csv("indiv_header_file.csv", header = FALSE)
    cm_header <<- read.csv("cm_header_file.csv", header = FALSE)
    cn_header <<- read.csv("cn_header_file.csv", header = FALSE)
    setwd("../")
}

read.data <- function(year_dir) {
    ## Reads political contribution from year_dir directory. 
    ## Assumes that there exists in year_dir: itcont.txt, cm.txt, cn.txt
    print(year_dir)
    # move to data/raw_data/year_dir
    #setwd("data")
    setwd(paste(raw_data.path, year_dir, sep="/"))
    # read individual contribution file
    print("Read individual contributions")
    indiv_contribs <- read.table(file = "itcont.txt", header = FALSE, sep = "|", quote = "\"", comment.char = "")
    names(indiv_contribs) <- as.character(unlist(indiv_header[1,]))
    # reduce to 'Harvard' employees
    indiv_contribs <- indiv_contribs[grep("HARVARD", indiv_contribs$EMPLOYER),]
    # read committee master file
    print("Read committee master")
    cm <- read.table(file = "cm.txt", header = FALSE, sep = "|", quote = "\"", comment.char = "")
    names(cm) <- as.character(unlist(cm_header[1,]))
    # read candidate master file
    print("Read candidate master")
    cn <- read.table(file = "cn.txt", header = FALSE, sep = "|", quote = "", comment.char = "")
    names(cn) <- as.character(unlist(cn_header[1,]))
    # merge data frames
    print("Merging")
    iccm <- merge(x = indiv_contribs, y = cm, by = "CMTE_ID", all.x = TRUE)
    iccmcn <- merge(x = iccm, y = cn, by = "CAND_ID", all.x = TRUE)
    # return to project dir
    setwd("../../")
    return(iccmcn)
}

read.all <- function() {
    set.headers()
    # run on all raw_data folders "/XX-YY" and output "XX-YY.csv"
    for (i in seq(14, 2, -2)) {
        year_dir <- paste(as.character(i-1), as.character(i), sep="-")
        write.csv(read.data(year_dir), paste(year_dir, "csv", sep="."))
    }
}
