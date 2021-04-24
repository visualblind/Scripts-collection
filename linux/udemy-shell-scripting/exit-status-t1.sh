#!/bin/bash

ls -l ./abc.txt

if [ $? -ne 0 ]
then
	exit 4
fi

./exit_t2.sh
if [ $? -ne 0 ]
then
	exit 5
fi


echo "This is the normal termination"
exit 0
