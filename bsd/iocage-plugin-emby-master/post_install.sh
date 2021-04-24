#!/bin/sh

# Install the binary package
#pkg add --force https://github.com/MediaBrowser/Emby.Releases/releases/download/4.2.0.1/emby-server-freebsd11_4.2.0.1_amd64.txz
pkg add --force https://github.com/MediaBrowser/Emby.Releases/releases/download/4.1.1.0/emby-server-freebsd11_4.1.1.0_amd64.txz

# Enable the service
sysrc -f /etc/rc.conf emby_server_enable="YES"

# Start the service
service emby-server start 2>/dev/null
