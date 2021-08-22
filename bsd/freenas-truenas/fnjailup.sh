#!/bin/bash
#
# fnupdate.sh
#
# Version 1.0
#
#
# Cyberjock on FreeNAS forums (c)2014. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ''AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

if [ -z "$1" ]
  then
    echo "Usage:"
	echo " -A			Audit all running jails with pkg-ng."
	echo " -C 			Cleanup old packages from the pkg-ng cache"
	echo " -O			Remove orphaned packages"
	echo " -U 			Upgrade all running packages with pkg-ng."
	echo " -V			Do a version comparison of pkg-ng itself."
	echo 
	echo " -p			Pause after each jail completes its task."
	echo " -y			If done with -U will not prompt for confirmation"
	echo "			to download packages for installation."
	echo 
	echo "Version 1.0 (June 4, 2014)"
	echo
	echo "============================================================================"
	echo "Reminder:  Your jails must be running when using this script."
	echo 
	echo "WARNING:  It is always recommended you make a snapshot of your jail before doing"
	echo "any updates to software as updates may cause erratic behavior."
	exit
fi

# Make sure that we are running as root
if [ "`id -u`" -ne "0" ]; then
	echo "Must run as root."
	exit
fi

# Check to make sure we are using pkg-ng 1.2.7 or higher
for jid in $( jls jid ); do
	jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
	pkgversion=`jexec -u root $jid /usr/sbin/pkg -v`
		if [ ! -z $pkgversion ]; then
		IFS=. read -a version_parts <<< "${pkgversion%%_*}"
	
		if [[ "${version_parts[0]}" -lt 1 ]] || ([[ "${version_parts[0]}" -eq 1 ]] && [[ "${version_parts[1]}" -lt 2 ]]) || ([[ "${version_parts[0]}" -eq 1 ]] && [[ "${version_parts[1]}" -eq 2 ]] && [[ "${version_parts[2]}" -lt 7 ]]); then
			echo "Error: pkg-ng version is < 1.2.7 for jail $jailname."
			echo "This script requires pkg-ng version to be 1.2.7 or higher."
			echo "Please update your pkg-ng version and try again."
			echo "No changes have been made to your jails."
			exit 1
		fi
	else
		echo "Error: pkg-ng not installed or version not understood"
		echo "in jail $jailname."
		exit 1
	fi
done

pause=0
audit_all=
upgrade_all=
version_compare=
freebsd_update_all=
clean_all=
orphaned=
confirmation=

while getopts ACOpUVy flag; do
	case "$flag" in
	A) audit_all=1 ;;
	C) clean_all=1 ;;
	O) orphaned=1 ;;
	p) pause=1 ;;
	U) upgrade_all=1 ;;
	V) version_compare=1 ;;
	y) confirmation=1 ;;
	\?) exit 1
	esac
done

shift $(( $OPTIND - 1 ))
if [ "$audit_all" ]; then
	for jid in $( jls jid ); do
		jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
		echo "============================================="
		echo "Performing a package audit of jail $jailname."
		jexec -u root $jid /usr/sbin/pkg audit
		if [ $pause -eq 1 ]; then
			jexec -u root $jid /usr/bin/read -p "Press a key to continue" VARNAME
		fi
	done
elif [ "$upgrade_all" ]; then
	for jid in $( jls jid ); do
		jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
		echo "============================================="
		echo "Performing a pkg-ng upgrade of jail $jailname."
		jexec -u root $jid /usr/sbin/pkg update >> /dev/null
		if [ "$confirmation" ]; then
			echo "haha"
			jexec -u root $jid /usr/sbin/pkg upgrade -y
		else
			jexec -u root $jid /usr/sbin/pkg upgrade
		fi
		if [ $pause -eq 1 ]; then
			jexec -u root $jid /usr/bin/read -p "Press a key to continue" VARNAME
		fi
	done
elif [ "$version_compare" ]; then
	for jid in $( jls jid ); do
		jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
		echo "============================================="
		echo "Performing a pkg-ng version check of jail $jailname."
		jexec -u root $jid /usr/sbin/pkg update >> /dev/null
		jexec -u root $jid /usr/sbin/pkg version | grep pkg-
		if [ $pause -eq 1 ]; then
			jexec -u root $jid /usr/bin/read -p "Press a key to continue" VARNAME
		fi
	done
elif [ "$orphaned" ]; then
	for jid in $( jls jid ); do
		jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
		echo "============================================="
		echo "Removing orphaned packages from jail $jailname."
		jexec -u root $jid /usr/sbin/pkg autoremove -y >> /dev/null
		if [ $pause -eq 1 ]; then
			jexec -u root $jid /usr/bin/read -p "Press a key to continue" VARNAME
		fi
	done
elif [ "$clean_all" ]; then
	for jid in $( jls jid ); do
		jailname=`jls | awk '/ '$jid' /' | awk '{print $3}'`
		echo "============================================="
		echo "Performing a pkg-ng cache clean of jail $jailname."
		jexec -u root $jid /usr/sbin/pkg clean -y >> /dev/null
		if [ $pause -eq 1 ]; then
			jexec -u root $jid /usr/bin/read -p "Press a key to continue" VARNAME
		fi
	done
fi

echo "============================================================================"
echo "Reminder:  Your jails must be running when using this script."
echo 
echo "WARNING:  It is always recommended you make a snapshot of your jail before doing"
echo "any updates to software as updates may cause packages installed to no longer"
echo "behave properly."
exit 0
