#!/bin/sh

basedir=$1;
hours="24";
dirs="$basedir/../htdocs/images/temp $basedir/temp $basedir/../logs";
tmpwatch="/usr/sbin/tmpwatch --ctime -f $hours";

for DIR in $dirs
do
    echo -n "Cleaning $hours hs. old files in $DIR ...";
    if [ -d "$DIR" ]; then
    	$tmpwatch $DIR
    	/bin/touch $DIR/.check
    	echo "done.";
    else 
	echo "error.";
    fi
done
