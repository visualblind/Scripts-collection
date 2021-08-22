#!/usr/bin/env zsh
mount -o union -t nullfs /mnt/pool3/p3ds0smb/media/video-tech /mnt/pool0/p0ds0smb/media/video-tech
mount -o union -t nullfs /mnt/pool3/p3ds0smb/media/podcasts /mnt/pool0/p0ds0smb/media/podcasts
mount -o union -t nullfs /mnt/pool3/p3ds0smb/media/video-starcraft /mnt/pool0/p0ds0smb/media/video-starcraft
mount -o union -t nullfs /mnt/pool3/p3ds0smb/media/video-tennis /mnt/pool0/p0ds0smb/media/video-tennis
mount -o union -t nullfs /mnt/pool1/p1ds0smb/Music /mnt/pool0/p0ds0smb/Music
mount -o union -t nullfs /mnt/pool1/p1ds0smb/OS /mnt/pool0/p0ds0smb/OS
mount -o union -t nullfs /mnt/pool1/p1ds0smb/software_android /mnt/pool0/p0ds0smb/software_android
mount -o union -t nullfs /mnt/pool1/p1ds0smb/software_linux /mnt/pool0/p0ds0smb/software_linux
mount -o union -t nullfs /mnt/pool1/p1ds0smb/software_wintel /mnt/pool0/p0ds0smb/software_wintel
mount -o union -t nullfs /mnt/pool1/p1ds0smb/Games /mnt/pool0/p0ds0smb/Games
mount -o union -t nullfs /mnt/pool1/p1ds0smb/backup /mnt/pool0/p0ds0smb/backup
mount -o union -t nullfs /mnt/pool1/p1ds0smb/media/video-standup /mnt/pool0/p0ds0smb/media/video-standup
mount -o union -t nullfs /mnt/pool3/p3ds0smb/media/video-movies /mnt/pool0/p0ds0smb/media/video-movies
mount -o union -t nullfs /mnt/pool1/p1ds0smb/software_vmware /mnt/pool0/p0ds0smb/software_vmware
#mount -o union -t nullfs /mnt/pool3/p3ds0smb/unionfs/video-shows /mnt/pool0/p0ds0smb/media/video-shows
mount -o union -t nullfs /mnt/pool3/p3ds0smb/unionfs/video-shows /mnt/pool0/p0ds0smb/unionfs/media/video-shows
mount -o union -t nullfs /mnt/pool0/p0ds0smb/media/video-shows /mnt/pool0/p0ds0smb/unionfs/media/video-shows