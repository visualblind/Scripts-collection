
awk '{printf $4;  for(i=5;i<=NF;i++){printf " %s", $i} printf "\n"}' < history-export-file