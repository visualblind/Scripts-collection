#Mount share with read/write
mount -t cifs //server-name/share-name /mnt/cifs -o rw,username=UserAccount,password='UserPassword',domain=domainname,addr=10.10.10.10,file_mode=0755,dir_mode=0755
#Mount share with read-only
mount -t cifs //server-name/share-name /mnt/cifs -o ro,username=UserAccount,password='UserPassword',domain=domainname,addr=10.10.10.10,file_mode=0755,dir_mode=0755