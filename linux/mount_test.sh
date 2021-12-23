#!/usr/bin/env bash

mkdir -p /tmp/foo/{a,b}
cd /tmp/foo

sudo mount -o bind a b
touch a/file
ls b/ # should show file
rm -f b/file
ls a/ # should show nothing

[[ $(findmnt -M b) ]] && echo "Mounted"
sudo umount b
[[ $(findmnt -M b) ]] || echo "Unmounted"