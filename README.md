### Harvard Political Contributions

#### About

This repository contains data on the political contributions of Harvard faculty, administrators, and staff between 2001 and Election Day 2014. It is derived from FEC Individual Contribution [data disclosures](http://www.fec.gov/finance/disclosure/ftpdet.shtml) over that time period. 

A subset of contributors who gave between 2011 and 2014 have been manually verified as Harvard employees, and data on the gender, school, and position of those contributors is also provided. 

Analysis of the data can be found in ```analysis.R```.

#### Data

* ```harvard-contributions.csv```: all Harvard political contributions, 2001 - 2014. 
* ```harvard-contributions-tagged.csv```: Harvard political contributions, with additional employment data, 2011 - 2014. 
* ```harvard-people.csv```: verified Harvard contributors, with additional employement data, 2011 - 2014.  
* ```harvard-employers.csv```: self-reported employer field values taken to fall within the scope of Harvard University, 2011 - 2014. 

Note: the values in ```harvard-employers.csv``` are those that were used to filter the raw FEC individual contribution data down to contributions made by those who were or are Harvard University employees. These employer values are self-reported by contributors, but were reduced to values that are institutions within the University (as in, 'Harvard Business School,' but not 'Harvard Childcare' or other employers who merely have the word 'Harvard' in their names). 

#### Building From Source Data

For transparency's sake, I've included ```build.R```, the R script that were used to parse and merge the raw FEC individual contribution files and filter them by Harvard employee. It assumes that the raw FEC data, which is released in two year chunks, is organized such that the data files for 2011-2012 can be found in ```data/raw_data/11-12```, for example, and it assumes that the header files provided by the FEC are in ```data/header```. 

You can download the raw individual contribution, committee, and candidate data [here](http://www.fec.gov/finance/disclosure/ftpdet.shtml). I didn't include them in the repo because they comprise several million rows spanning nearly 15 years.  
