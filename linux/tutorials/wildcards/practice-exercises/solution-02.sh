#!/bin/bash

# YYYY-MM-DD
DATE=$(date +%F)

read -p "Please enter a file extension: " EXTENSION
read -p "Please enter a file prefix:  (Press ENTER for ${DATE}). " PREFIX

if [ -z "$PREFIX" ]
then
  PREFIX="$DATE"
fi

for FILE in *.${EXTENSION}
do
  NEW_FILE="${PREFIX}-${FILE}"
  echo "Renaming $FILE to ${NEW_FILE}."
  mv $FILE ${NEW_FILE}
done
