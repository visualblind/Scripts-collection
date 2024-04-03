#!/bin/bash
# Based on Adafruit Learning Technologies Onion Pi project
# More info: http://learn.adafruit.com/onion-pi

if (( $EUID != 0 )); then 
   echo "This must be run as root. Try 'sudo bash $0'." 
   exit 1 
fi


echo "
$(tput setaf 2)              .~~.   .~~.
$(tput setaf 6)   /         $(tput setaf 2)'. \ ' ' / .'$(tput setaf 6)         \ 
$(tput setaf 6)  |   /       $(tput setaf 1).~ .~~~..~.$(tput setaf 6)       \   |
$(tput setaf 6) |   |   /  $(tput setaf 1) : .~.'~'.~. :$(tput setaf 6)   \   |   |
$(tput setaf 6)|   |   |   $(tput setaf 1)~ (   ) (   ) ~$(tput setaf 6)   |   |   |
$(tput setaf 6)|   |  |   $(tput setaf 1)( : '~'.~.'~' : )$(tput setaf 6)   |  |   |
$(tput setaf 6)|   |   |   $(tput setaf 1)~ .~ (   ) ~. ~ $(tput setaf 6)  |   |   |
$(tput setaf 6) |   |   \   $(tput setaf 1)(  : '~' :  )$(tput setaf 6)   /   |   |
$(tput setaf 6)  |   \       $(tput setaf 1)'~ .~~~. ~'$(tput setaf 6)       /   |
$(tput setaf 6)   \              $(tput setaf 1)'~'$(tput setaf 6)              / 
$(tput bold ; tput setaf 4)            Raspberry PiFi$(tput sgr0)

"

echo "$(tput setaf 6)This script will configure your Raspberry Pi as a wireless access point.$(tput sgr0)"
read -p "$(tput bold ; tput setaf 2)Press [Enter] to begin, [Ctrl-C] to abort...$(tput sgr0)"

echo "$(tput setaf 6)Updating packages...$(tput sgr0)"
apt-get update -q -y

echo "$(tput setaf 6)Installing hostapd...$(tput sgr0)"
apt-get install hostapd

echo "$(tput setaf 6)Installing ISC DHCP server...$(tput sgr0)"
apt-get install isc-dhcp-server

echo "$(tput setaf 6)Configuring ISC DHCP server...$(tput sgr0)"
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak
sed -i -e 's/option domain-name "example.org"/# option domain-name "example.org"/g' /etc/dhcp/dhcpd.conf
sed -i -e 's/option domain-name-servers ns1.example.org/# option domain-name-servers ns1.example.org/g' /etc/dhcp/dhcpd.conf
sed -i -e 's/#authoritative;/authoritative;/g' /etc/dhcp/dhcpd.conf
echo -e "subnet 192.168.42.0 netmask 255.255.255.0 {
range 192.168.42.10 192.168.42.50;
option broadcast-address 192.168.42.255;
option routers 192.168.42.1;
default-lease-time 600;
max-lease-time 7200;
option domain-name \042local\042;
option domain-name-servers 8.8.8.8, 8.8.4.4;
}" >> /etc/dhcp/dhcpd.conf
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
sed -i -e 's/INTERFACES=""/INTERFACES="wlan0"/g' /etc/default/isc-dhcp-server

echo "$(tput setaf 6)Turning off wlan0 if active...$(tput sgr0)"
ifdown wlan0

echo "$(tput setaf 6)Updating network interfaces...$(tput sgr0)"
mv /etc/network/interfaces /etc/network/interfaces.bak
echo "auto lo

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0

iface wlan0 inet static
  address 192.168.42.1
  netmask 255.255.255.0
" > /etc/network/interfaces

echo "$(tput setaf 6)Assigning static IP address 192.168.42.1...$(tput sgr0)"
ifconfig wlan0 192.168.42.1

echo "$(tput setaf 6)Configuring hostapd...$(tput sgr0)"
echo "$(tput bold ; tput setaf 2)Type a 1-32 character SSID (name) for your PiFi network, then press [ENTER]:$(tput sgr0)"
read ssid
echo "$(tput setaf 6)PiFi network SSID set to $(tput bold)$ssid$(tput sgr0 ; tput setaf 6). Edit /etc/hostapd/hostapd.conf to change.$(tput sgr0)"

pwd1="0"
pwd2="1"
until [ $pwd1 == $pwd2 ]; do
  echo "$(tput bold ; tput setaf 2)Type a password to access your PiFi network, then press [ENTER]:$(tput sgr0)"
  read -s pwd1
  echo "$(tput bold ; tput setaf 2)Verify password to access your PiFi network, then press [ENTER]:$(tput sgr0)"
  read -s pwd2
done

if [ $pwd1 == $pwd2 ]; then
  echo "$(tput setaf 6)Password set. Edit /etc/hostapd/hostapd.conf to change.$(tput sgr0)" 
fi

echo "interface=wlan0
driver=rtl871xdrv
ssid=$ssid
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$pwd1
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf

echo "$(tput setaf 6)Setting hostapd to run at system boot...$(tput sgr0)"
cp /etc/default/hostapd /etc/default/hostapd.bak
sed -i -e 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

echo "$(tput setaf 6)Setting IP forwarding to start at system boot...$(tput sgr0)"
cp /etc/sysctl.conf /etc/sysctl.bak
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

echo "up iptables-restore < /etc/iptables.ipv4.nat" >> /etc/network/interfaces

echo "$(tput setaf 6)Activating IP forwarding...$(tput sgr0)"
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

echo "$(tput setaf 6)Setting up IP tables to interconnect ports...$(tput sgr0)"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

echo "$(tput setaf 6)Saving IP tables...$(tput sgr0)"
sh -c "iptables-save > /etc/iptables.ipv4.nat"

echo "$(tput setaf 6)Fetching Adafruit's updated access point software...$(tput sgr0)"
wget http://www.adafruit.com/downloads/adafruit_hostapd.zip

echo "$(tput setaf 6)Decompressing adafruit_hostapd.zip...$(tput sgr0)"
unzip adafruit_hostapd.zip

echo "$(tput setaf 6)Updating hostapd...$(tput sgr0)"
mv /usr/sbin/hostapd /usr/sbin/hostapd.ORIG
mv hostapd /usr/sbin
chmod 755 /usr/sbin/hostapd

echo "$(tput setaf 6)Cleaning up...$(tput sgr0)"
rm adafruit_hostapd.zip

echo "$(tput setaf 6)Starting hostapd service...$(tput sgr0)"
service hostapd start

echo "$(tput setaf 6)Starting ISC DHCP server...$(tput sgr0)"
service isc-dhcp-server start

echo "$(tput setaf 6)Checking hostapd status...$(tput sgr0)"
service hostapd status
hostapd_result=$?

#if [ $hostapd_result == 3 ]; then
#  echo "ERROR: hostapd start failed."
#  exit 1
#fi

echo "$(tput setaf 6)Checking ISC DHCP server status...$(tput sgr0)"
service isc-dhcp-server status
dhcp_result=$?

#if [ $dhcp_result == 3 ]; then
#  echo "ERROR: ISC DHCP server failed to start."
#  exit 1
#fi

echo "$(tput setaf 6)Setting hostapd to start on system boot...$(tput sgr0)"
update-rc.d hostapd enable

echo "$(tput setaf 6)Setting ISC DHCP server to start on system boot...$(tput sgr0)"
update-rc.d isc-dhcp-server enable

echo "$(tput setaf 6)Removing WPASupplicant...$(tput sgr0)"
mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service ~/

echo "$(tput setaf 6)Rebooting...$(tput sgr0)"
reboot

exit 0
