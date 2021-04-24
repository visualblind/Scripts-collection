#!/bin/sh
apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}')
