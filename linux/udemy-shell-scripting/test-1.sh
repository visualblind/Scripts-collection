#!/bin/bash

filename="messages.log"
if [ -e  $filename ]
then
	echo "$filename Exist"
fi

if [ -f  $filename ]
then
	echo "$filename Exist and is a regular file"
fi

filename="sdcd1"
if [ -b $filename ]
then
	echo "$filename is a block device file"
fi


filename="sdcp1"
if [ -c $filename ]
then
	echo "$filename is a character device file"
fi

filename="zebra_logs"
if [ -d $filename ]
then
	echo "$filename is a directory"
fi


