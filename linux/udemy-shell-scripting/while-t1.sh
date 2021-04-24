#!/bin/bash

count=0

while [ $count -lt 5 ]
do
	echo "hello there"
	sleep 1
	count=$((count+1))
done
