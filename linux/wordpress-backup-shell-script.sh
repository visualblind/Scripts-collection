#!/bin/bash

# This script creates a compressed backup archive of the given directory and the given MySQL table. More details on implementation here: http://theme.fm
# Feel free to use this script wherever you want, however you want. We produce open source, GPLv2 licensed stuff.
# Author: Konstantin Kovshenin exclusively for Theme.fm in June, 2011

# Set the date format, filename and the directories where your backup files will be placed and which directory will be archived.
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="travisrunyard.com.$NOW.tar"
BACKUP_DIR="/home/trunyard/backups"
WWW_DIR="/var/www/html"

# MySQL database credentials
DB_USER="wordpress"
DB_PASS="wordpress"
DB_NAME="wordpress"
DB_FILE="wordpress.$NOW.sql"

# Tar transforms for better archive structure.
WWW_TRANSFORM='s,/var/www/html,www,'
DB_TRANSFORM='s,^home/trunyard/backups,database,'

# Create the archive and the MySQL dump
tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
mysqldump -u$DB_USER -p$DB_PASS -$DB_NAME > $BACKUP_DIR/$DB_FILE

# Append the dump to the archive, remove the dump and compress the whole archive.
tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
rm $BACKUP_DIR/$DB_FILE
gzip -9 $BACKUP_DIR/$FILE