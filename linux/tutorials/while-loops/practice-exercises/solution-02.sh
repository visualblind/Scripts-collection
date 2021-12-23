#!/bin/bash

read -p "How many lines of /etc/passwd would you like to see? " SHOW_LINES

LINE_NUM=1
while read LINE
do
 if [ "$LINE_NUM" -gt "$SHOW_LINES" ]
 then
   break
 fi
 echo $LINE
 ((LINE_NUM++))
done < /etc/passwd
