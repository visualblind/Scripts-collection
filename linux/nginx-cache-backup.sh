#!/bin/bash 

NGINXCACHEROOT="/root/nginx-cache"
NGINXCACHETMPFS="/run/nginx-cache"
PIDFILE="/tmp/nginx-cache-backupd.pid" 

function d_start ( ) 
{ 
	echo  "nginx-cache-backupd: starting service" 
#	nginx-cache-backupd --pidfile = $PIDFILE
	

	if [ ! -d $NGINXCACHEROOT ]
	then
	/bin/cp -R $NGINXCACHETMPFS $NGINXCACHEROOT
	else
	/bin/rm -r $NGINXCACHEROOT
        /bin/cp -R $NGINXCACHETMPFS $NGINXCACHEROOT
	fi

logger --journald << EOF
MESSAGE_ID=67feb6ffbaf24c5cbec13c008dd72304
MESSAGE=Logging syslog entry upon ExecStart
SYSTEMD_UNIT="nginx-cache-backupd.service"
EOF

	echo  "PID is $(cat $PIDFILE)"
}
 
function d_stop ( ) 
{ 
	echo  "nginx-cache-backupd: stopping Service (PID = $(cat $PIDFILE))" 
	kill $(cat $PIDFILE)
	#echo $PID
	#kill $PID
	rm $PIDFIL

        if [ ! -d $NGINXCACHEROOT ]
        then
        /bin/cp -R $NGINXCACHETMPFS $NGINXCACHEROOT
        else
        /bin/rm -r $NGINXCACHEROOT
        /bin/cp -R $NGINXCACHETMPFS $NGINXCACHEROOT
        fi

logger --journald << EOF
MESSAGE_ID=67feb6ffbaf24c5cbec13c008dd72391
MESSAGE=Logging syslog entry upon ExecStart
SYSTEMD_UNIT="nginx-cache-backupd.service"
EOF
        echo  "PID is $(cat $PIDFILE)"
 
}
 
function d_status ( ) 
{ 
	ps  -ef  |  grep nginx-cache-backupd |  grep  -v  grep 
	echo "PID indicate indication file $(cat $PIDFILE 2>/dev/null)" 
	echo "Size of /run/nginx-cache directory: `du -sh /run/nginx-cache/`"
        echo "Size of /root/nginx-cache directory: `du -sh /root/nginx-cache/`"
}
 
# Some Things That run always 
touch /tmp/nginx-cache-backupd.pid
 
# Management instructions of the service 
case  "$1"  in 
	start )
		d_start
		;; 
	stop )
		d_stop
		;; 
	restart|reload )
		d_stop
		sleep  1
		d_start
		;; 
	status )
		d_status
		;; 
	* ) 
	echo  "Usage: $ 0 {start | stop | reload | status}" 
	exit  1 
	;; 
esac
 
exit  0
