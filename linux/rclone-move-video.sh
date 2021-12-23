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
    echo "usage: rclone-move-video.sh [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
}

while [ "$1" != "" ]; do
    case $1 in
        -b | --bandwidth )      shift
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
bash -c "rclone move --bwlimit "$BANDWIDTH"M --progress --size-only --transfers 5 \
--checkers 4 --tpslimit 4 --tpslimit-burst 4 --update --filter-from \
$HOME/.config/rclone/filter-staging-video.txt --drive-acknowledge-abuse --drive-use-trash=false \
--log-level INFO --delete-during --log-file $HOME/.config/rclone/log/upload-gcrypt-usmba.log \
--no-traverse --drive-stop-on-upload-limit \
/mnt/pool0/p0ds0smb/media_staging gcrypt-usmba:/p0ds0smb"

screen -S $SCREEN_NAME -X colon "logfile flush 0^M"

find /mnt/pool0/p0ds0smb/media_staging/video-*/* -depth -type d -empty -print0 | xargs -0 -I {} /bin/rmdir "{}"

