find / -mount -size +10240k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }' | sort

find / -type f -size +102400k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'