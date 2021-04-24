#!/bin/bash
apt remove --purge $(dpkg -l| grep $1| awk '{ print $2 }'| xargs) || exit 1
