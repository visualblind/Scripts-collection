#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 PATTERN STRINGS..."
    exit 1
fi
regex=$1
shift
echo "regex: $regex"
echo

while [[ $1 ]]
do
    if [[ $1 =~ $regex ]]; then
        echo "$1 matches"
        i=1
        n=${#BASH_REMATCH[*]}
        while [[ $i -lt $n ]]
        do
            echo "  capture[$i]: ${BASH_REMATCH[$i]}"
            let i++
        done
    else
        echo "$1 does not match"
    fi
    shift
done