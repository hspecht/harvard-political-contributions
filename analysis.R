##
##   analysis.R: statistical analysis on political contributions of Harvard 
##               employees
##

## Libraries
# install.packages("zoo", "reshape2")
library("zoo")
library("reshape2")

## Data Sets
# all contribution data, filtered down to Harvard employees, from 2001 - 2014
people <- read.csv("harvard-people.csv")  
contribs.tagged <- read.csv("harvard-contributions-2011-2014-tagged.csv")

# ALL CONTRIBUTIONS (2001 - 2014)
contribs <- read.csv("harvard-contributions.csv")
names(contribs)
# read TRANSACTION_DT as Date objects
contribs$TRANSACTION_DT <- as.Date(contribs$TRANSACTION_DT)
# add a column for year-month
contribs$YEARMON <- as.yearmon(contribs$TRANSACTION_DT) 
# DEM = Democratic, REP = Republican, DFL = Democratic-Farmer-Labor, GRE = Green
# IND = Independent, NNE = None, UNK = Unknown
# UNK contributions are to Women's Campaign Party = non-partisan
# contribs[which(contribs$PARTY == "UNK"),]
# DFL is affiliated with DEM, so we merge them
levels(contribs$PARTY)
levels(contribs$PARTY) <- c("DEM", "DEM", "GRE", "IND", "NP", "REP", "NP", "NP")
levels(contribs$PARTY)
# breakdown sum/median of donations by party by month
d <- as.data.frame(as.list(aggregate(TRANSACTION_AMT ~ PARTY + YEARMON, data = contribs, sum)))
m1 <- acast(d, PARTY~YEARMON, value.var='TRANSACTION_AMT', fill=0)
# three-month rolling mean
m1.rm <- t(m1); m1.rm[,1:5] <- rbind(rbind(rep(0, 5), rollmean(t(m1), 3)), rep(0, 5)); m1.rm <- t(m1.rm)
barplot(m1, col=c("blue", "green", "yellow", "grey", "red"), main="Harvard Political Contributions, 2011-2014:\n Total Contributions, by Month",
        xlab="Date", ylab="Amount (USD)", xpd=FALSE, border=TRUE)
legend('topright', legend=row.names(m1), fill=c("blue", "green", "yellow", "grey", "red"))
# add lines for elections months - day doesn't matter because smallest unit is month
elections.pres <- as.yearmon(as.Date(c("01 Nov 2004", "01 Nov 2008", "01 Nov 2012"), format="%d %b %Y"))
elections.mid <- as.yearmon(as.Date(c("01 Nov 2002", "01 Nov 2006", "01 Nov 2010", "1 Nov 2014"), , format="%d %b %Y"))
abline(v=elections.pres, col="darkorchid4"); abline(v=elections.mid, col="darkorchid1")

# PEOPLE
# Unique employees who contributed between 2011 and 2014
nrow(people) # 913 unique verified contributors between 2011 and 2014
# Gender
# 358 F, 555 M
# 39.2% F, 60.8% M
table(people$GENDER)
round(prop.table(table(people$GENDER)), 3)
# School
# merge schools with < 10 contributors into OTHER (except HMC)
levels(people$SCHOOL) <- c("CADM","FAS","OTHER","GSE","OTHER","HBS","HKS","HLS","HMC",
                           "HMS","OTHER","OTHER","OTHER","SEAS","SPH","OTHER")
table(people$SCHOOL)
round(prop.table(table(people$SCHOOL)), 3)
# Title
table(people$TITLE)
round(prop.table(table(people$TITLE)), 3)
# School vs. Gender
school.gender.table <- table(people$SCHOOL, people$GENDER); school.gender.table
school.gender.perc <- round(prop.table(school.gender.table, 1), 3); school.gender.perc
# average gender distribution per school
# 41% female, 59% male
school.gender.favg <- mean(school.gender.perc[,1])
school.gender.mavg <- mean(school.gender.perc[,2])
school.gender.favg; school.gender.mavg
# Gender vs. Title
title.gender.table <- table(people$TITLE, people$GENDER); title.gender.table
title.gender.perc <- round(prop.table(title.gender.table, 1), 3); title.gender.perc

# TAGGED CONTRIBUTIONS (2011 - 2014)
# Contribution data, tagged with gender/school/title, from 2011 - 2014
names(contribs.tagged)
# add level merges for SCHOOL from people data frame
levels(contribs.tagged$SCHOOL) <- c("CADM","FAS","OTHER","GSE","OTHER","HBS","HKS","HLS","HMC",
                                    "HMS","OTHER","OTHER","OTHER","SEAS","SPH","OTHER")
# Add a column with formatted transaction date
contribs.tagged$TRANSACTION_DT <- as.Date(sprintf("%08d", contribs.tagged$TRANSACTION_DT), '%m%d%Y')
# contributions between 01-04-2011 and 10-15-2014
summary(contribs.tagged$TRANSACTION_DT)
# only 47 contributions greater than $5000
hist(contribs.tagged$TRANSACTION_AMT, breaks="FD", freq=TRUE)
# let's break it down by school
# first, merge CAND and CMTE party affiliation to get party
#contribs.tagged$PARTY <- ifelse(!(contribs.tagged$CMTE_PTY_AFFILIATION == ""), as.character(contribs.tagged$CMTE_PTY_AFFILIATION), as.character(contribs.tagged$CAND_PTY_AFFILIATION))
# now, look at total contributions (amt + count) per party per school
party.school.sum <- aggregate(TRANSACTION_AMT ~ PARTY + SCHOOL, data = contribs.tagged, sum); party.school.sum
party.school.freq <- aggregate(TRANSACTION_AMT ~ PARTY + SCHOOL, data = contribs.tagged, length); party.school.freq
# now per party per school
party.title.freq <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE, data = contribs.tagged, length)
party.title.freq <- party.title.sum[order(party.title.freq$TRANSACTION_AMT, decreasing=TRUE),]; party.title.freq
party.title.sum <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE , data = contribs.tagged, sum)
party.title.sum <- party.title.sum[order(party.title.sum$TRANSACTION_AMT, decreasing=TRUE),]; party.title.sum
party.title.mean <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE , data = contribs.tagged, mean)
party.title.mean <- party.title.mean[order(party.title.mean$TRANSACTION_AMT, decreasing=TRUE),]; party.title.mean
# per party per gender
party.gender.sum <- aggregate(TRANSACTION_AMT ~ CMTE_PTY_AFFILIATION + GENDER, data = contribs.tagged, sum); party.gender.sum 
party.gender.freq <- aggregate(TRANSACTION_AMT ~ GENDER + CMTE_PTY_AFFILIATION, data = contribs.tagged, length); party.gender.freq
