#/bin/bash

for pkg in `sudo dpkg --get-selections | awk '{print $1}' | egrep -v '(dpkg|apt|mysql|mythtv)'` ; do sudo apt-get -y --force-yes install --reinstall $pkg ; done
