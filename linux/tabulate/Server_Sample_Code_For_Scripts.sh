#!/bin/sh


# This script concatenates HTML Hyperlinking Syntax to the Fields 
# Specified by us below. A sample Input and Output Data Text Files 
# and a Server_Sample.html are specified right at the bottom of this script. Viewing them first with a Text Editor/Browser will help you understand this script better.
#
# awk command uses the following general syntax:
# -F stands for Input Field Separator, which is a ~ ( tilde ) in this case. Generally, Tilde (~), Pipe (|), Backtick (`), Bang (!) are good choices for delimiters, also known as Input Field Separators. Ask for input files with any of this delimiter from your clients.
# OFS is Output Field Separator, which is a | ( i.e. pipe ) in this case. This option will help you to convert from one delimiter to another.
# NR is the Number of Record. It is checked to skip the heading (first) record and does the concatenating from second record onwards.
# Edit the syntax as per your input data and requirements.
# SQ="'" declares the Single Quote Variable, which is used by the HTML Syntax Everywhere for denoting its values. 
# ($1!=""?html_syntax:"") checks if the first field is empty or not. If not empty, it concatenates the html syntax, otherwise returns an empty string. The same structure is repeated with different field numbers.


awk -F'~' -v SQ="'" 'BEGIN{OFS="|"} NR==1 {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}; 
NR>1 {print $1, 
($1!=""?"<a href=" SQ "./images/" $1 ".pdf" SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">Profile Download</a>":""),
$2,
($2!=""?"<a href=" SQ "tel:" $2 SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">" $2 "</a>":""),
$3,
($3!=""?($3 ~ /:/?"<a href=" SQ $3 SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">Home Page</a>":"<a href=" SQ "http://" $3 SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">Home Page</a>"):""),
$4,
($4!=""?"<img src=" SQ "./images/" $4 SQ " alt=" SQ "./images/" $4 SQ " width=" SQ "50" SQ " height=" SQ "50" SQ " style=" SQ "border:5px solid black" SQ ">":""),
($4!=""?"<a href=" SQ "./images/" $4 SQ " alt=" SQ "./images/" $4 SQ " target=" SQ "_blank" SQ "> <img src=" SQ "./images/" $4 SQ " alt=" SQ "./images/" $4 SQ " width=" SQ "50" SQ " height=" SQ "50" SQ " style=" SQ "border:5px solid black" SQ "></a>":""),
$5,
($5!=""?"<a href=" SQ "mailto:" $5 SQ " target=" SQ "_blank" SQ " rel=" SQ "noopener noreferrer" SQ ">Send email</a>":"")
};' Server_Sample.csv > Server_Sample_to_tabulate.csv


cat "Server_Sample_to_tabulate.csv" | { cat ; echo ; } | ./tabulate.sh -d "|" -t "HTML Features" -h "HTML Features" > "Server_Sample.html"