#!/bin/bash

df_func()
{
	disk_drive=$1
	df -kh ${disk_drive}
}

echo "This program displays the disk free space"
df_func /dev/sda
