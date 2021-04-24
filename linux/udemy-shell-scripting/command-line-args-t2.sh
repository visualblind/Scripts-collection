#!/bin/bash

## This $* treats all the command line argument as
## one single argument when present in quotes as
## "$*"
for i in "$*"
do
	echo $i
done


## $@ treats the arguments as individual arguments 
for i in "$@"
do
	echo $i
done

