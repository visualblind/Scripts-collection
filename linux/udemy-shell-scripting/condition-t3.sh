#!/bin/bash

count=-3

if [ $count -gt 0 ] ; then
	echo "Count is positive"
	printf "My current working directory is \n $PWD \n"
elif [ $count -lt -2 ]
then
	echo "count is less than -2" 
fi
