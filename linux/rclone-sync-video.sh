#!/usr/bin/env bash

RCLONE_CONFIG=/root/.config/rclone/rclone.conf
SCREEN_NAME=$(basename "$0" | cut -d '.' -f 1)
BANDWIDTH=${1:-6}

export BANDWIDTH
export RCLONE_CONFIG
export SCREEN_NAME

curl -fsS --retry 3 https://hc-ping.com/375838da-679b-4a64-9482-514c534ca4ce > /dev/null || wget https://hc-ping.com/375838da-679b-4a64-9482-514c534ca4ce -O /dev/null

#exit if running
if ! [[ $(screen -S "$SCREEN_NAME" -Q select .) ]]; then
    echo "$SCREEN_NAME is already running, exiting..."
    exit 1
fi

usage()
{
    echo "usage: rclone-sync-video.sh [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
}

while [ "$1" != "" ]; do
    case $1 in
        -b | --bandwidth )	shift
                                BANDWIDTH=$1
				export BANDWIDTH
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

screen -dmS $SCREEN_NAME -L -Logfile $HOME/.config/rclone/log/gcrypt-usmba.log \
bash -c "rclone sync --bwlimit "$BANDWIDTH"M --progress --checksum --transfers 8 \
--checkers 8 --tpslimit 8 --tpslimit-burst 8 --update --filter-from \
$HOME/.config/rclone/filter-file-video.txt --drive-acknowledge-abuse --drive-use-trash=true \
--log-level INFO --delete-during --log-file $HOME/.config/rclone/log/upload-gcrypt-usmba.log \
/mnt/pool0/p0ds0smb/media gcrypt-usmba:/p0ds0smb"

screen -S $SCREEN_NAME -X colon "logfile flush 0^M"
