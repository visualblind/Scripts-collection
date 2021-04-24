#
# set static ip
#
sudo -i
echo "" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "    address 192.168.1.2" >> /etc/network/interfaces
echo "    netmask 255.255.255.0" >> /etc/network/interfaces
echo "    gateway 192.168.1.1" >> /etc/network/interfaces
echo "    dns-search internal.example.com" >> /etc/network/interfaces
echo "    dns-nameservers 8.8.8.8 8.8.4.4" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
echo "nameserver 8.8.4.4" >> /etc/resolvconf/resolv.conf.d/head
echo "" >> /etc/resolvconf/resolv.conf.d/head
resolvconf -u
reboot
exit