#!/bin/bash
#sysinfo.io
#change paths below to suit your needs
dockerdir_new='/docker/var/'
dockerdir_old='/var/lib/docker/'

set -e
dockerdir_new2=$(echo "$dockerdir_new" | sed 's/\//\\\//g')
systemctl stop docker
mkdir -p $dockerdir_new
rsync -a $dockerdir_old* $dockerdir_new
sed -i.bak "/ExecStart=\/usr\/bin\/dockerd \-H fd:\/\//c ExecStart=\/usr\/bin\/dockerd \-H fd:\/\/ -g ${dockerdir_new2}" /lib/systemd/system/docker.service
mv $dockerdir_old /var/lib/docker.bak/
ln -s $dockerdir_new /var/lib/docker
systemctl daemon-reload
systemctl start docker.service
printf '\n* The Docker systemd config has been backed up to /lib/systemd/system/docker.service.bak\n* A backup of the old Docker Root has been copied to /var/lib/docker.bak/\n\n'
docker info | grep 'Root Dir'
