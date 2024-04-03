#!/usr/bin/env bash

# top 10 largest directories
du -a /var | sort -n -r | head -n 10

# top 10 largest directories skipping different file-systems
du -a -x /var | sort -n -r | head -n 10

# more compatible looping version
for i in G M K
do
  du -ah | grep "[0-9]$i" | sort -nr -k 1
done | head -n 11


