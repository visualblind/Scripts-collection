dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge

apt-get autoremove -y; apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}')

apt-get update && apt-get upgrade -y; apt-get autoremove -y; dpkg --list | grep '^rc' | cut -d ' ' -f 3 | xargs sudo dpkg --purge
apt-get update && apt-get upgrade -y; apt-get autoremove -y; apt-get purge -y $(dpkg --list |grep '^rc' |awk '{print $2}')