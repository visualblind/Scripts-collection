#!/bin/bash

string1="Hi There"
string2=""

##  n is true if lenght of string is nonzero.
if [ -n "$string1" ]
then
	echo "length of the string is nonzero"
else
	echo "length of the string is zero"
fi
	

## Z is for comparsion if string length is zero
if [ -z "$string1" ]
then
	echo "length of the string is zero"
else
	echo "length of the string is non-zero"
fi
