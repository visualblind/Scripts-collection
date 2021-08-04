#!/usr/bin/env bash
set -e
gnome-terminal --tab --title='gcrypt-usmba' -- watch -n 1 tail -n 14 /media/visualblind/rclone/root/root/.config/rclone/log/gcrypt-usmba.log && \
gnome-terminal --tab --title='gdrive-servercopy' -- watch -n 1 tail -n 14 /media/visualblind/rclone/root/root/.config/rclone/log/gdrive-servercopy.log && \
gnome-terminal --tab --title='gcrypt-p0ds0smb' -- watch -n 1 tail -n 14 /media/visualblind/rclone/root/root/.config/rclone/log/gcrypt-usmba-p0ds0smb.log && \
gnome-terminal --tab --title='up gcrypt-usmba' -- tail -fn 75 /media/visualblind/rclone/root/root/.config/rclone/log/upload-gcrypt-usmba.log && \
gnome-terminal --tab --title='up gdrive-servercopy' -- tail -fn 75 /media/visualblind/rclone/root/root/.config/rclone/log/upload-gdrive-servercopy.log && \
gnome-terminal --tab --title='up gcrypt-p0ds0smb' -- tail -fn 75 /media/visualblind/rclone/root/root/.config/rclone/log/upload-gcrypt-usmba-p0ds0smb.log
#gnome-terminal --tab --title='up media-extra' -- tail -fn 75 /media/visualblind/rclone/root/root/.config/rclone/log/upload-mediaextra.log
#gnome-terminal --tab --title='up software-extra' -- tail -fn 75 /media/visualblind/rclone/root/root/.config/rclone/log/upload-softwareextra.log
