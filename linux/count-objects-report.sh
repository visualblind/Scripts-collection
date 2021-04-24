#!/usr/bin/env bash

#Report count of files and directories together as objects for each 2nd-level directory
for directory in */ ; do D=$(readlink -f "$directory") ; echo $D = $(find "$D" -mindepth 1 | wc -l) ; done

#Report objects (sum of subdirectories + files), files, and subdirectories
for directory in temp/ ; do D=$(readlink -f "$directory") ; echo "$D (Objects = $(find "$D" -mindepth 1 | wc -l), Files = $(find "$D" -mindepth 1 -type f | wc -l), Subdirs = $(find "$D" -mindepth 1 -type d | wc -l))" ; done