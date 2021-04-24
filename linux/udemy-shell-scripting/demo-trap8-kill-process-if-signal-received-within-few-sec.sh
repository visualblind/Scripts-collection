#!/bin/bash

old_time=
new_time=

cleanup()
{
	echo " Some cleanup performed "
	new_time=`date +%s`    ## This would give time since epoch
	time_diff=$((new_time-old_time))
	if [ $time_diff -gt 0 ] && [ $time_diff -lt 3 ] 
	then
		echo "Exiting program as key pressed within $time_diff"
		exit 1
	else
		old_time=$new_time
	fi
}

trap 'cleanup SIGINT' SIGINT

while true
do
	echo "hello"
	sleep 1
done
