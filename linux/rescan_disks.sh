# Reference: http://blog.gurudelleccelsopicco.org/2009/09/online-lun-expansion-and-partition-resizing-without-reboot-under-linux/

echo 1 > /sys/block/[DEVICE]/device/rescan

# DETECT IF NEW DISKS ARE ATTACHED TO THE HOST 

# Reference: http://www.cyberciti.biz/tips/vmware-add-a-new-hard-disk-without-rebooting-guest.html

ls /sys/class/scsi_host

# Output:
# host0 host1 ...

# Now type the following to send a rescan request:
echo "- - -" > /sys/class/scsi_host/host0/scan

fdisk -l

# OR 

ls /sys/class/scsi_host/ | while read host ; do echo "- - -" > /sys/class/scsi_host/$host/scan ; done
