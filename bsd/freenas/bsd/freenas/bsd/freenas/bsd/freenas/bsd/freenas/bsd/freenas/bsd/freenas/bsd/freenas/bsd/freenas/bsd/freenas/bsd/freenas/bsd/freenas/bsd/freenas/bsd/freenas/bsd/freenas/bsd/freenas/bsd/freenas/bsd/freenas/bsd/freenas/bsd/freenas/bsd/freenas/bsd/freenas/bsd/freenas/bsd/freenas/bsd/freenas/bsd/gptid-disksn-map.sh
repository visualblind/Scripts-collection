for FILE in /dev/da0 /dev/da1 /dev/da2 /dev/da3 /dev/da4 /dev/da5 /dev/da6 /dev/da7 /dev/da8; do echo -n "${FILE}: "; smartctl -a $FILE | grep 'Serial Number'; done
