parted
cfdisk
fdisk -l /dev/...
pvcreate /dev/...
pvdisplay
vgextend vgname /dev/...
lvdisplay
lvextend -l+100%FREE /dev/vgname/root
resize2fs /dev/mapper/ubuntu1604--template--vg-root
df -h

#mkfs -t ext4 /dev/sdb
#fdisk -l
#/dev/sdb /docker ext4 defaults 1 3



