#!/bin/bash

## This program generates a random number between
## 1 1000

for i in `seq 1 20`
do
	var=$((RANDOM%100))
	cp fruit_list.txt fruit_list_${var}.txt
done
