#!/bin/bash

if [ $(id -u) = "0" ]
then
	echo "You are  a superuser"
else
	echo "You are not a superuser, your ID is $(id -u)"
fi
	
