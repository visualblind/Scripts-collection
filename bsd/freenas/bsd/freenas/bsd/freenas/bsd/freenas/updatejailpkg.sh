#!/usr/local/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "-------- updating pkg in ${jail} --------"
    jexec "${jail}" sed -i '' 's/:10:/:9:/' /usr/local/etc/pkg/repos/FreeBSD.conf
    jexec "${jail}" pkg update -f
    jexec "${jail}" pkg-static install -f pkg
    jexec "${jail}" pkg upgrade -f
    jexec "${jail}" /usr/sbin/freebsd-update fetch
    jexec "${jail}" /usr/sbin/freebsd-update install
    echo "------- completed init ${jail} -------"
done
