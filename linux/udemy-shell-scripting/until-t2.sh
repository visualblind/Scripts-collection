#!/bin/bash

count=3

until [ $count -le 0 ]
do
	echo "Hi there"
	count=$((count-1))
	echo "value of count=$count"
	sleep 1
done
