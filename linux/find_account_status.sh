passwd -S -a | grep L | cut -d " " -f1
passwd -S -a |awk '/L/{print $1}'
passwd -S -a |awk '/P/{print $1}'