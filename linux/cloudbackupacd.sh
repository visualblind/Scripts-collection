#!/usr/local/bin/bash

#
# this script will sync local directories up to a cloud backup provider, such as Amazon Cloud Drive mjt 11/20/2016
#

# perform rclone cloud backup nightly to Amazon Cloud Drive mjt 1/5/2017
# 30 0 * * * /root/cloudBackupACD.bash
#

umask 0

LOGDIR=/media/logsRCLONE-ACD
DATAMOUNTROOT=/media
PARALLEL_TRANSFERS=8

#
# use 2M for 2Mbyte upload limit
#
BWLIMIT=4M

trap 'echo interrupted; exit' INT

echo Started at `date` .

if test -e $DATAMOUNTROOT ; 
then 
	echo "$DATAMOUNTROOT mounted. Please continue."
	cd $DATAMOUNTROOT
	for i in music live backup musicHD musicHDmultichannel bluray2017
	do
		echo `date`
		echo "syncing $DATAMOUNTROOT/$i to Amazon Cloud Backup via rclone"
	#
	# cd to the specific subdir to do the rsync 
 	#
		cd "$DATAMOUNTROOT/$i"
		(/usr/sbin/rclone --transfers $PARALLEL_TRANSFERS --bwlimit $BWLIMIT sync $DATAMOUNTROOT/$i AmazonCloud:$i 2>&1) | tee "$LOGDIR"/RCLONE-ACD-backup-$i-`date +%Y%m%d%H%M%S.txt`
	done
else
	echo "$DATAMOUNTROOT not mounted. Please retry!"
fi

# 
# finally, remove txt files older than 30 days
#
find $LOGDIR -name \*.txt -type f -mtime +30 -exec rm {} \;
#


echo Finished at `date` .
