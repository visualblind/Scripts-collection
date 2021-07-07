#!/usr/local/bin/bash
SHELL=/usr/local/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/root/bin
#JAIL_PORTS=/mnt/jails/ports

#updates shared ports dir that is null mounted into each jail
#portsnap -p $JAIL_PORTS fetch update &>/dev/null || echo "Updating ports tree failed!"

# if you don't have a shared ports mount, then use this.
# this will take a long time to run for each jail.

for JID in $(jls -h jid | grep '^[0-9]' | awk '{ print $1 }');do
    jail=$(jls -h jid name | grep "^$JID " | awk '{ print $2 }')
    jailpath=$(jls -h jid path | grep "^$JID " | awk '{ print $2 }')
    echo "#!/usr/local/bin/bash" > "$jailpath/root/updateports.sh"
    echo "/usr/sbin/portsnap cron update" >> "$jailpath/root/updateports.sh"
    echo "if [ \$? -ne 0 ]; then" >> "$jailpath/root/updateports.sh"
    echo "echo \"Updating ports tree failed for jail \${1}!\"" >> "$jailpath/root/updateports.sh"
    echo "fi" >> "$jailpath/root/updateports.sh"
    chmod 700 "$jailpath/root/updateports.sh"
    jexec $JID "/root/updateports.sh" $jail
done
