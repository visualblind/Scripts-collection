for FILE in /dev/da1 /dev/da2 /dev/da3 /dev/da4 /dev/da5 /dev/da6; do echo -n "${FILE}: "; smartctl -a $FILE | grep Serial Number; done
