#!/usr/bin/env bash
#service openvpn status && curl ipconfig.io && service openvpn stop && sleep 5 && curl ipconfig.io && service openvpn start && sleep 5

VPNSERVICE="openvpn"
TORRENTSERVICE="transmission"

function check_ip() {
ipa=$(curl ipconfig.io 2>/dev/null)

echo -e "$ipa"
check_ovpn="ps -ef | grep -v grep | grep $VPNSERVICE | wc -l"
check_transmission="ps -ef | grep -v grep | grep $TORRENTSERVICE | wc -l"

if [ "$ipa" == '47.157.247.170' ]; then
	echo -e "IP is home ($ipa) ...\nStarting the VPN service..."
	#echo $ipa
	if [ '$check_ovpn < 1' ]; then
		service $VPNSERVICE start
		sleep 5
		return
	else
		echo -e "VPN already started...\nStarting $TORRENTSERVICE ..."
	fi
else
	echo -e "IP IS NOT HOME: $ipa"
	if [ '$check_transmission < 1' ]; then
	service transmission start
	else
	echo "transmission already running, exiting..."
	exit $?
	fi
fi
}
check_ip || exit $?
