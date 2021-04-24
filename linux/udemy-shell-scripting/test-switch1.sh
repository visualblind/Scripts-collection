#!/bin/bash

echo "Enter a number, between 1 to 4. Type "quit" to exit"

while [ 1 ]
do
	read mynum
	case $mynum in
		1) echo "Its a one"
			;;
		2) echo "Its a two"
			;;
		3) echo "Its a three"
			;;
		4) echo "Its a four"
			;;
		"quit") echo "You want to quit"
			break
			;;
		*) echo "Oops its not allowd"
		;;
	esac
done	

	
echo "After the while loop"
