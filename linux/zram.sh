modprobe zram num_devices=1 
# max ram usage = 256 Mbytes
echo 262144 > /sys/block/zram0/disksize
mke2fs -q -m 0 -b 4096 -O sparse_super -L zram /dev/zram0
mount -o relatime,noexec,nosuid /dev/zram0 /tmp