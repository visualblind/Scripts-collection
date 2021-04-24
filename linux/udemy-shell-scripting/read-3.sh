#!/bin/bash

read -a my_array

for i in ${my_array[@]}
do
	echo "The number input is $i"
done
