#!/bin/sh
sysrc -f /etc/rc.conf transmission_enable="YES"
sysrc -f /etc/rc.conf transmission_download_dir="/usr/local/etc/transmission/home/Downloads"
# Start service once to create the files needed
service transmission start
sleep 2 # It can take a few seconds.
service transmission stop
sleep 2 # If it's still running, our changes won't propagate, as they're lost on restart. This is to be safe.

# Without the whitelist disabled, the user will not be able to access it. They can reenable and manually whitelist their IP's.
SETTINGS="/usr/local/etc/transmission/home/settings.json"
echo "Disabling RPC whitelist, you may want to reenable it with the specific IP's you will access transmission with by editing $SETTINGS"
sed -i '' 's/    "rpc-whitelist-enabled": true,/    "rpc-whitelist-enabled": false,/' $SETTINGS

#Create a Download Directory
mkdir -p /usr/local/etc/transmission/home/Downloads
chmod 755 /usr/local/etc/transmission/home/Downloads

# Start the service
service transmission start
