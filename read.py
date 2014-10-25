""" 
    read.py: read in political contribution data from html of FEC query results and write to csv. 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""

import os
import csv
import re

from bs4 import BeautifulSoup

raw_html_dir = "/raw_html/"
wd = os.getcwd()

def get_filenames():
    """ Return filenames of raw html files in raw_html_dir. """

    raw_html_path = os.getcwd() + raw_html_dir
    files = os.listdir(raw_html_path)
    fnum = lambda x : int(os.path.splitext(x)[0])
    files = sorted(files, key=lambda x : fnum(x)) # sort by file number 
    return files

def read_files(files):
    """ 
        Reads raw html from files and returns list of (filename, 
        BeautifulSoup(file)) tuples. 
    """
    fcontents = []
    nfiles = len(files)
    nread = 0
    print '>> READING RAW HTML FILES'
    for fname in files:
        fp = wd + raw_html_dir + fname
        f = open(fp, 'r')
        try:
            raw_html = f.read()
            fcontents.append((fname, BeautifulSoup(raw_html)))
            print '\t' + fname 
            nread += 1
        finally:
            f.close()
    print "{0} of {1} files read".format(nread, nfiles)
    return fcontents

def write(data, fname):
    with open(file, "wb") as f:
        writer = csv.writer(f, delimiter=',')
        for line in data:
            writer.writerow(line)

read_files(get_filenames())
