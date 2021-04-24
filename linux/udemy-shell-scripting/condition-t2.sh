#!/bin/bash

count=-3

if [ $count -gt 0 ] ; then
	echo "Count is positive"
	printf "My current working directory is \n $PWD \n"
else
	echo "count is Negative"
fi
