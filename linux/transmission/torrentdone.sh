#!/usr/local/bin/bash
# Transmission script to move torrent files

#################################################################################
#                     Transmission Environment Variables                        #
#################################################################################

# TR_APP_VERSION - Transmission's short version string, e.g. 4.0.0
# TR_TIME_LOCALTIME
# TR_TORRENT_BYTES_DOWNLOADED - Number of bytes that were downloaded for this torrent
# TR_TORRENT_DIR - Location of the downloaded data
# TR_TORRENT_HASH - The torrent's info hash
# TR_TORRENT_ID
# TR_TORRENT_LABELS - A comma-delimited list of the torrent's labels
# TR_TORRENT_NAME - Name of torrent (not filename)
# TR_TORRENT_PRIORITY - The priority of the torrent (Low is "-1", Normal is "0", High is "1")
# TR_TORRENT_TRACKERS - A comma-delimited list of the torrent's trackers' announce URLs

#################################################################################
#                                   VARIABLES                                   #
#################################################################################

LOGFILE="/usr/local/etc/transmission/home/scripts/torrentdone.log"
RSYNC_LOGFILE="/usr/local/etc/transmission/home/scripts/torrentdone_rsync.log"
TORRENT_PATH="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
TORRENT_DESTPATH="/mnt/p3ds0smb/temp/ffmpeg-vcodec/"

#################################################################################
#                                 SCRIPT CONTROL                                #
#################################################################################

# Log script events
function edate 
{
  echo "$(date '+%Y-%m-%d %H:%M:%S')    $1" >> "$LOGFILE"
}

edate "__________________________NEW TORRENT FILE__________________________"
edate "Transmission version: $TR_APP_VERSION"
edate "Time: $TR_TIME_LOCALTIME"
edate "Torrent name: $TR_TORRENT_NAME"
edate "Directory: $TR_TORRENT_DIR"
edate "Torrent Hash: $TR_TORRENT_HASH"
edate "Torrent ID: $TR_TORRENT_ID"
edate "Downloaded: $TR_TORRENT_BYTES_DOWNLOADED"
edate "Full Torrent Path: $TORRENT_PATH"

/usr/local/bin/rsync --recursive --update --ignore-existing --itemize-changes --progress --human-readable \
	--stats --verbose --log-file="$RSYNC_LOGFILE" --include="*/" --include="*.mkv" --include="*.mp4" \
	--include="*.srt" --include="*.avi" --exclude="*" "$TORRENT_PATH" $TORRENT_DESTPATH


