#
#   analysis.R: statistical analysis on political contributions of Harvard employees
#

## Data Sets
# all contribution data, filtered down to Harvard employees, from 2001 - 2014
contribs <- read.csv("harvard-contributions.csv")
people <- read.csv("people_tagged_unique.csv")  
contribs.tagged <- read.csv("contributions_11-14_tagged.csv")

# HELPER FUNCTIONS
# show counts and percentages via contingency table
tabulate <- function(cols) {
    print(table(cols))
    print(round(prop.table(table(cols)), 3))
}

# PEOPLE
# Unique employees who contributed between 2011 and 2014
names(people) # get a look at the columns
nrow(people) # 1216 unique verified contributors between 2011 and 2014
# Gender
# 457 F, 756 M
# 38% F, 62% M
tabulate(people$GENDER)
# School
# 25% in FAS, 15% in HLS, HMS, HBS, 7% in SPH
tabulate(people$SCHOOL)
# Title
# 46% professors, 22% administrators, 26 Univ. professors
tabulate(people$TITLE)
# School vs. Gender
school.gender.table <- table(people$SCHOOL, people$GENDER); school.gender.table
school.gender.perc <- round(prop.table(school.gender.table, 1), 3); school.gender.perc
# average gender distribution per school
# 30% female, 63% male
school.gender.favg <- mean(school.gender.perc[,2])
school.gender.mavg <- mean(school.gender.perc[,3])
school.gender.favg; school.gender.mavg
# Gender vs. Title
# administrators are 59% female, associate professors are 57% male, asst. profs are 67% male, instructors are 75% female
# professors are 75% male, senior fellows are 85% male, senior lecturers are 58% male, univ. profs are 92% male
title.gender.table <- table(people$TITLE, people$GENDER); title.gender.table
title.gender.perc <- round(prop.table(title.gender.table, 1), 3); title.gender.perc

# TAGGED CONTRIBUTIONS (2011 - 2014)
# Contribution data, tagged with gender/school/title, from 2011 - 2014
names(contribs.tagged)
# Add a column with formatted transaction date
contribs.tagged$DATE <- as.Date(sprintf("%08d", contribs.tagged$TRANSACTION_DT), '%m%d%Y')
# contributions between 01-04-2011 and 09-30-2014
summary(contribs.tagged$DATE)
# histogram of # contribs / month
hist(contribs.tagged$DATE, breaks="months", freq=TRUE)
# mean contributions: $952.4, median: $500, min: $200, max: $73300
summary(contribs.tagged$TRANSACTION_AMT)
# only 47 contributions greater than $5000
hist(contribs.tagged$TRANSACTION_AMT, breaks="FD", freq=TRUE)
# let's break it down by school
# first, merge CAND and CMTE party affiliation
# contribs.tagged$PARTY <- ifelse(!is.na(contribs.tagged$CMTE_PTY_AFFILIATION), as.character(contribs.tagged$CMTE_PTY_AFFILIATION), as.character(contribs.tagged$CAND_PTY_AFFILIATION))
# now, look at total contributions (amt + count) per party per school
party.school.sum <- aggregate(TRANSACTION_AMT ~ PARTY + SCHOOL, data = contribs.tagged, sum); 
party.school.freq <- aggregate(TRANSACTION_AMT ~ PARTY + SCHOOL, data = contribs.tagged, length); party.school.freq
# now per party per school
party.title.freq <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE, data = contribs.tagged, length)
party.title.freq <- party.title.sum[order(party.title.freq$TRANSACTION_AMT, decreasing=TRUE),]; party.title.freq
party.title.sum <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE , data = contribs.tagged, sum)
party.title.sum <- party.title.sum[order(party.title.sum$TRANSACTION_AMT, decreasing=TRUE),]; party.title.sum
party.title.mean <- aggregate(TRANSACTION_AMT ~ PARTY + TITLE , data = contribs.tagged, mean)
party.title.mean <- party.title.mean[order(party.title.mean$TRANSACTION_AMT, decreasing=TRUE),]; party.title.mean
# per party per gender
party.gender.sum <- aggregate(TRANSACTION_AMT ~ PARTY + GENDER, data = contribs.tagged, sum); party.gender.sum 
party.gender.freq <- aggregate(TRANSACTION_AMT ~ PARTY + GENDER, data = contribs.tagged, length); party.gender.freq

