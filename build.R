#
#   build.R: build Harvard political contribution data from 2000 - 2014
#

# directory names
data.path    <- "data"
header.path  <- "header"
# data filenames
indiv.fname  <- "itcont.txt"
cm.fname     <- "cm.txt"
cn.fname     <- "cn.txt"
# file to write data
output.fname <- "harvard_pol_contribs.csv"

set.headers <- function() {
    ## Read in header files and define global variables
    setwd(header.path)
    indiv.header <- "indiv_header_file.csv"
    cm.header    <- "cm_header_file.csv"
    cn.header    <- "cn_header_file.csv"
    indiv_header <<- read.csv("indiv_header_file.csv", header = FALSE)
    cm_header <<- read.csv("cm_header_file.csv", header = FALSE)
    cn_header <<- read.csv("cn_header_file.csv", header = FALSE)
    setwd("../")
}

read.data <- function(year_dir) {
    ## Reads political contribution from year_dir directory. 
    ## Assumes that there exists: itcont.txt, cm.txt, cn.txt
    
    print(year_dir)
    # move to year_dir
    setwd(paste(data.path, year_dir, sep="/"))
    # read individual contribution file
    print("... read individual contributions")
    indiv_contribs <- read.table(file = "itcont.txt", header = FALSE, sep = "|", quote = "\"", comment.char = "")
    names(indiv_contribs) <- as.character(unlist(indiv_header[1,]))
    # reduce to 'Harvard' employees
    indiv_contribs <- indiv_contribs[grep("HARVARD", indiv_contribs$EMPLOYER),]
    # read committee master file
    print("... read committee master")
    cm <- read.table(file = "cm.txt", header = FALSE, sep = "|", quote = "\"", comment.char = "")
    names(cm) <- as.character(unlist(cm_header[1,]))
    # read candidate master file
    print("... read candidate master")
    cn <- read.table(file = "cn.txt", header = FALSE, sep = "|", quote = "", comment.char = "")
    names(cn) <- as.character(unlist(cn_header[1,]))
    # merge data frames
    print("... merging")
    iccm <- merge(x = indiv_contribs, y = cm, by = "CMTE_ID", all.x = TRUE)
    iccmcn <- merge(x = iccm, y = cn, by = "CAND_ID", all.x = TRUE)
    # return to project dir
    setwd("../../")
    return(iccmcn)
}

read.all <- function() {
    set.headers()
    ## Create new global 'harvard' data frame with data from 2001 - 2014
    # instantiate global data frame with data from 2013-2014
    harvard <<- read.data("13-14")
    # read and merge other year dirs
    for (i in seq(12, 2, -2)) {
        # generate directory name
        year_dir <- paste(as.character(i-1), as.character(i), sep="-")
        # append new data frame to global data frame
        print("combining into global data frame")
        harvard <<- rbind(harvard, read.data(year_dir))
    }
    write.csv(harvard, output.fname)
}