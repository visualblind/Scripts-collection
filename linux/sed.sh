/ExecStart=\/usr/bin/dockerd \-H fd:///c ExecStart=\/usr/bin/dockerd \-H fd:// \-g /docker/var/docker\/g' /lib/systemd/system/docker.s
ervice

/ExecStart=\/usr/bin/dockerd \-H fd:///c ExecStart=/usr/bin/dockerd \-H fd:// \-g /docker/var/docker/g' /lib/systemd/system/docker.service

sed '/ExecStart=\/usr\/bin\/dockerd \-H fd:\/\/c ExecStart=\/usr\/bin\/dockerd \-H fd:\/\/ -g \/docker\/var\/docker/g' /lib/systemd/system/docker.service

#Remove all backslashes
sed 's/\\//g'

#Add escaped backslashes for sed input
newdir='/new/docker/dir/'
newdir_esc=$(sed 's./.\\/.g' $newdir)
sed 's./.\\/.g' '\new\docker\dir\'

newdir2=$(sed 's|/|\\/|g' <<< $newdir)
newdir3=${newdir2//\//\\/} 

newdir2=$(sed 's/\//\\/g' <<< $newdir) # foward to backward slash

newdir2=$(sed 's/\\/\//g' <<< $newdir) # backward to forward slash
sed 's/\//\\/g' # forward to backward slash
sed 's/\\/\//g' # backward to forward slash

echo $newdir | sed 's/\//\\\//g'

#!/bin/bash

#Change the paths below to suit your needs
dockerdir_new='/new/docker/dir/'
dockerdir_old='/var/lib/docker'
dockerdir_new2=$(sed 's/\//\\\//g' <<< $dockerdir_new)

systemctl stop docker
mkdir -p $dockerdir_new
rsync -a $dockerdir_old $dockerdir_new

sed -i.bak "/ExecStart=\/usr\/bin\/dockerd \-H fd:\/\//c ExecStart=\/usr\/bin\/dockerd \-H fd:\/\/ -g ${dockerdir_new2}" /lib/systemd/system/docker.service