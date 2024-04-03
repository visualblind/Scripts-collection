#!/usr/bin/env bash

while true; do date; ps auxf | awk '{if($8=="D") print $0;}'; sleep 1; done
