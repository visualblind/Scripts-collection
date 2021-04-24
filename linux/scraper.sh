#!/bin/sh
while read line; do
  # replace http://
  stripped_url=`echo $line| cut -c8-`
#  stripped_url=`echo $line`
  target_folder="downloads/`echo $stripped_url|sed 's/\//_/g'`"
  echo $stripped_url
  echo ""
  echo ""
  echo ""
  echo "Scraping $stripped_url"
  echo "-----------------------------------"
  echo "> creating folder.."
  echo $target_folder
  mkdir -p $target_folder
  echo "> scraping $stripped_url"
  wget -e robots=off \
    -H -nd -nc -p \
    --recursive \
    --level=1 \
    --accept jpg,jpeg \
    -P $target_folder $line
  echo ""
  echo ""
  echo "> Finished scraping $stripped_url"
done < sites.txt
