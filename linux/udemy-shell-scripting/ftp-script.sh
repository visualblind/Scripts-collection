#!/bin/bash

## NOte, ftp are insecure and no more used.
# FTP sends the password in plain text.
# This program ios for demonstration about the 
# use case of Here Document for automating the 
# things

ftp_server="10.71.213.45"
user_name="anonymous"
password="anon@anon.museum.com"
directory_where_file_is_present="myfolder"
FILENAME="filename.txt"

ftp -n $ftp_server  << EOF
quote USER $user_name 
quote PASS $password
cd $directory_where_file_is_present
bin
hash
get $FILENAME
quit
EOF

