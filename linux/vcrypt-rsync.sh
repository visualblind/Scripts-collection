#!/usr/bin/env bash
rsync -rltzuv --delete --log-file='/home/visualblind/Documents/rsyncvcrypt.log' /media/visualblind/p0ds0smb/visualblind/Documents/ /media/veracrypt1/Documents/ && \
rsync -rltzuv --delete --log-file='/home/visualblind/Documents/rsyncvcrypt.log' ~/Downloads/ /media/veracrypt1/Downloads/
