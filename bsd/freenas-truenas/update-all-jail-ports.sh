#!/usr/local/bin/bash

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    echo "-------- updating ${jail} --------"
    #jexec $JID portmaster -y -P -a

    jexec $JID pkg update

    jexec $JID portmaster --no-confirm -adw
    jexec $JID portmaster -y -y -d -s
    
    #jexec $JID portmaster -y -t --clean-distfiles
    echo "-------- completed ${jail} -------"
    echo ""
    echo ""
done
