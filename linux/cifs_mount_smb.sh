#Mount share with read/write
mount -t cifs //server-name/share-name /mnt/cifs -o rw,username=UserAccount,password='UserPassword',domain=domainname,addr=10.10.10.10,file_mode=0755,dir_mode=0755
#Mount share with read-only
mount -t cifs //server-name/share-name /mnt/cifs -o ro,username=UserAccount,password='UserPassword',domain=domainname,addr=10.10.10.10,file_mode=0755,dir_mode=0755

#fstab mount read-only share for webserver user www-data
//server-name/share-name /mnt/share cifs credentials=/root/.smbcredentials,domain=domainname,uid=www-data,gid=www-data,ro,vers=1.0,uid=33,forceuid,gid=33
,forcegid,addr=10.10.10.10,file_mode=0755,dir_mode=0755 0 0

#/root/.smbcredentials
username=UserAccount
password=UserPassword