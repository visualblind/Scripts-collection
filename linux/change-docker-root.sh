#!/bin/bash

#Change the paths below to suit your needs
dockerdir_new='/new/docker/dir/'
dockerdir_old='/var/lib/docker'
dockerdir_new2=$(sed 's/\//\\\//g' <<< $dockerdir_new)

systemctl stop docker
mkdir -p $dockerdir_new
rsync -a $dockerdir_old $dockerdir_new

sed -i.bak "/ExecStart=\/usr\/bin\/dockerd \-H fd:\/\//c ExecStart=\/usr\/bin\/dockerd \-H fd:\/\/ -g ${dockerdir_new2}" /lib/systemd/system/docker.service
