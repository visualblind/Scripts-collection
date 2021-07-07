#!/usr/local/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "-------- initializing ${jail} --------"
    $DIR/initialize-jail-ports.sh "${jail}"
    echo "------- completed init ${jail} -------"
done
