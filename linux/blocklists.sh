#!/usr/bin/env bash
curl -s https://www.iblocklist.com/lists.php \
  | sed -n "s/.*value='\(http:.*=bt_.*\)'.*/\1/p" \
  | xargs wget -O output.txt \
  | gunzip \
  | egrep -v '^#'
