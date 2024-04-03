#!/usr/bin/env bash

RCLONE_CONFIG=/root/.config/rclone/rclone.conf
SCREEN_NAME=$(basename "$0" | cut -d '.' -f 1)
BANDWIDTH=${1:-2}
export BANDWIDTH
export RCLONE_CONFIG
#export SCREEN_NAME

curl -fsS --retry 3 https://hc-ping.com/1f03f0e8-00b3-4876-bfbd-53785bdaf1d8 > /dev/null || wget https://hc-ping.com/1f03f0e8-00b3-4876-bfbd-53785bdaf1d8 -O /dev/null

usage()
{
	echo "usage: $(basename "$0") [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
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

#exit if running
if ! [[ $(screen -S "$SCREEN_NAME" -Q select .) ]]; then
    echo "$SCREEN_NAME is already running, exiting..."
    exit 1
fi

# <!!!!!!! NOTE !!!!!!!>
# While performing a server-side operation on Google Drive accounts, rclone will
# split the api requests in half for each remote. For example, using a tpslimit 
# of 4 will mean that tpslimit is set to 2 for each google drive account.
# If rclone sync errors, then runs again with drive-server-side-across-configs OFF

screen -dmS $SCREEN_NAME -L -Logfile $HOME/.config/rclone/log/gdrive-servercopy.log \
bash -c "rclone sync --drive-server-side-across-configs \
--drive-stop-on-upload-limit --tpslimit 4 --tpslimit-burst 4 --progress --verbose \
--delete-during --log-file $HOME/.config/rclone/log/upload-gdrive-servercopy.log \
--filter-from /root/.config/rclone/filters/rclone-servercopy.filter \
--drive-pacer-min-sleep 10ms --drive-pacer-burst 200 \
gdrive-usmba:gcrypt gdrive-gdrive01dvecs:gcrypt"

#rclone sync --drive-server-side-across-configs \
#--drive-stop-on-upload-limit --tpslimit 4 --tpslimit-burst 4 --progress --verbose \
#--delete-during --log-file $HOME/.config/rclone/log/upload-gdrive-servercopy.log \
#--exclude '/cu3lt3mmlcrmqh9i9rmf3b8530/**' \
#gdrive-usmba:gcrypt gdrive-gdrive02dvecs:gcrypt

screen -S $SCREEN_NAME -X colon "logfile flush 0^M"
