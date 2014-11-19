### Harvard Political Contributions

#### About

This repository contains data on the political contributions of Harvard faculty, administrators, and staff between 2001 and Election Day 2014. It is derived from FEC Individual Contribution [data disclosures](http://www.fec.gov/finance/disclosure/ftpdet.shtml) over that time period. 

A subset of contributors who gave between 2011 and 2014 have been manually verified as Harvard employees, and data on the gender, school, and position of those contributors is also provided. 

Analysis of the data can be found in ```analysis.R```.

#### Data

* ```harvard-contributions.csv```: all Harvard political contributions, 2001 - 2014. 
* ```harvard-contributions-tagged.csv```: Harvard political contributions, with additional employment data, 2011 - 2014. 
* ```harvard-people.csv```: verified Harvard contributors, with additional employement data, 2011 - 2014.  
* ```harvard-employers.csv```: self-reported employer field values taken to fall within the scope of Harvard University. 

Note: the values in ```harvard-employers.csv``` are those that were used to filter the raw FEC individual contribution data down to contributors who were or are Harvard University employees. These values are self-reported by contributors. 

#### Building From Source Data

For transparency's sake, I've included the R script (```build.R```) that were used to parse and merge the raw FEC individual contribution files and filter them by Harvard employee. 
