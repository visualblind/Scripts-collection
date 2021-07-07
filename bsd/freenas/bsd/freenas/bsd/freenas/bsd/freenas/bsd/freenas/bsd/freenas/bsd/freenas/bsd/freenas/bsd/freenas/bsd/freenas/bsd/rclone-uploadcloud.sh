#!/usr/bin/env bash
# RClone Config file
RCLONE_CONFIG=/data/rclone/rclone.conf
export RCLONE_CONFIG
LOCKFILE="/var/lock/`basename $0`"

(
  # Wait for lock for 5 seconds
  flock -x -w 5 200 || exit 1

# Move older local files to the cloud
/usr/bin/rclone move /data/local/ gcrypt: -P --checkers 3 --log-file /home/felix/logs/upload.log -v --tpslimit 3 --transfers 3 --drive-chunk-size 32M --exclude-from /home/felix/scripts/excludes --delete-empty-src-dirs

) 200> ${LOCKFILE}
