#!/usr/bin/env bash
transmission-remote -n visualblind:DrewGe*f8 -l | awk '$9 == "Finished"{ system("transmission-remote -n visualblind:DrewGe*f8 -t " $1 " -l -r" ) }' 2>&1
