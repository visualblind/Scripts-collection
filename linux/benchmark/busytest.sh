#!/bin/sh

### __                         #
###|__)    _  | _  _     _  _|_#
###|__)|_|_)\/|(_)(_).  | )(-|_#
###         /     _/           #
### busytest
### V 0.1 (2016)
### http://busylog.net         #
################################

# Debug
#set -x
# Debug
#set -v

#[TODO]>
#[TODO]> Complete the list of ftp servers ...
#[TODO]> ... the most important thing is to to know bandwidth of those servers
#[TODO]>
#Define connection params
# Server Name
FARM_FTP=('demo.wftpserver.com'
	#'test.talia.net'
	#'ftp.uconn.edu'
	'speedtest.tele2.net'
	'wen1-speedtest-1.tele2.net'
	'zgb-speedtest-1.tele2.net'
	'fra36-speedtest-1.tele2.net'
	'bks-speedtest-1.tele2.net'
	'vln038-speedtest-1.tele2.net'
	'ams-speedtest-1.tele2.net'
	'bck-speedtest-1.tele2.net'
	'kst5-speedtest-1.tele2.net'
	'nyc9-speedtest-1.tele2.net'
	)
# Server Comment
FARM_FTP_NOTE=('http://www.wftpserver.com/it/onlinedemo.htm'
	#'http://test.talia.net/'
	#'http://dlptest.com/ftp-test/ (not sure if can be used for purpose tests)'
	'http://speedtest.tele2.net/'
	'http://speedtest.tele2.net/ (Austria, Vienna)'
	'http://speedtest.tele2.net/ (Croatia, Zagreb)'
	'http://speedtest.tele2.net/ (Germany, Frankfurt)'
	'http://speedtest.tele2.net/ (Latvia, Riga)'
	'http://speedtest.tele2.net/ (Lithuania, Vilnius)'
	'http://speedtest.tele2.net/ (Netherlands, Amsterdam)'
	'http://speedtest.tele2.net/ (Sweden, Gothenburg)'
	'http://speedtest.tele2.net/ (Sweden, Stockholm)'
	'http://speedtest.tele2.net/ (USA, New York)'
	)
# Login UserName
FTP_USER=('demo-user'
	#'anonymous'
	#'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	'anonymous'
	)
# Login Password
FTP_PASS=('demo-user'
	#'anonymous@for.test'
	#'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	'anonymous@for.test'
	)
# Folder for Upload
FTP_FOLD=('upload'
	#'incoming'
	#"48_hour"
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	'upload'
	)
	
FILE_LOG="ftp_busy.log"
	
#
 #########################
 #DEFINE FNCs
 #########################
#

# Check what we have installed
#-=-
#[NOTE]> A way to do multiple statements per bash test && and || statement is to use { } is below...
# At beginning I thought to use ( ) subshell but I could not find a (easy) way to do it.
# However here I don't actually need it after && and || I can use more commands using { }
check_what_we_can_do(){
	echo "Check what we have installed here...";
	type -p "openssl" >/dev/null && { ISopenssl=1;	echo "openssl......installed (YES)"; }||{ echo "openssl......not installed (NO)"; }
	type -p "wget" >/dev/null && 	{ ISwget=1;		echo "wget.........installed (YES)"; }||{ echo "wget.........not installed (NO)"; }
	type -p "ftp" >/dev/null && 	{ ISftp=1;		echo "ftp..........installed (YES)"; }||{ echo "ftp..........not installed (NO)"; }
	type -p "ioping" >/dev/null &&	{ ISioping=1;	echo "ioping.......installed (YES)"; }||{ echo "ioping.......not installed (NO)"; }
	type -p "hdparm" >/dev/null &&	{ IShdparm=1;	echo "hdparm.......installed (YES)"; }||{ echo "hdparm.......not installed (NO)"; }
}


# Generate a random temporary file using dd command (filling the file with random contents).
#-=-
#[NOTE]> Use of mktemp, in order to create a temporary file, with a custom template filename XXXXXXXX.tmp
generate_bin() {
	file_name=$(mktemp -p . -t XXXXXXXX.tmp);
	if [ $? -ne 0 ]; then
        echo "$0: create file error..."
        exit 1
	fi
	
	echo "Generate temporary file  $file_name with size $((1024*$1))KB ... please wait a wile"
	dd if=/dev/urandom of=$file_name bs=1024K count=$1 2>&1 | grep copied
	if [ $? -ne 0 ]; then
        echo "$0: error while file was filling..."
        exit 1
	fi
	echo "Created"
}


# Delete random temporary file
#-=-
destroy_bin() {
	echo "Remove temporary file  $file_name"
	if [[ -z $file_name ]]; then
		echo "no temp file defined."	
	else
		rm $file_name
		if [ $? -ne 0 ]; then
       	 echo "$0: error in file deletion..."
		fi
	fi
}

# GEOLOCATION using http://ipinfo.io VERSION
#-=-
#[TODO]> is a incomplete implementation (don't use)
ipinfo_geolocation (){
	#[TODO]> improve output
	echo "! NEEDS IMPROVEMENT"
	nslookup $1 | awk '/^Address: / { print $2 ; exit }' | wget -qO - http://ipinfo.io/$(cat -) | grep "city\|region\|country\|org" | sed 's/[\" \t,]//g' tr "," " "
}

# GEOLOCATION using http://freegeoip.net/ VERSION
#-=-
freegeoip_geolocation (){
  wget -qO - http://freegeoip.net/csv/$1 | sed  's/,,/,unknow,/g;s/,,/,unknow,/g;'| awk -F "," '{print $6", "$5" ("$3")"}'
}

# Latency : repeat ping 5 times in order to get the avg. latency
#-=-
ftp_latency(){
	ping -c 5 $1 | grep 'min/avg/max/' | cut -d"/" -f 5
}

# Human readable ftp speed ouput
#-=-
#[TODO]> is a incomplete implementation (works only on Kb and returns only M and not Mi)
ftp_speed_hr (){
	awk '{IGNORECASE=1;if ($0 ~ /Kb/){ printf("%4.1f Mbps/s - %4.1f MB/s \n",$1*8/1000,$1/1000)} else {print "?"} }' <<<$1
}

# Connect to & upload the tmp file (100MB)
#-=-
#[TODO]>: improve error handling and reporting
#-=-
#[NOTE]> ftp interaction in a shell-script using Here-Documents (block delimited by <<END_SCRIPT)
#[NOTE]> In  "grep" the option -q suppresses the output result to standard output (stdout).
#        Grep exits immediately with zero status if any match is found, even if an error was detected.
#	     This is useful just to check the presence of substring in the output... and with || and && tests.
test_speed (){ 

# ftp interaction in a shell-script
OUT=$(ftp -v -n <<END_SCRIPT
open $1
quote USER $2
quote PASS $3
cd $4
binary
put $5
quit
END_SCRIPT
)

#grep -q avoid to printout the content of "$OUT" and grep exits zero status if any match is found, even if an error was detected.
grep -q "^226" <<<"$OUT" || echo "Transfer seems to be in error! (answer '226 Transfer complete' not found)"
#extract speed
echo "$OUT" | grep 'bytes sent in'| sed -e 's/.*(\(.*\))/\1/g'
}

# Trap control+c
#-=-
#trap ctrl-c and is handled by fnc control_c()
#[NOTE]> Enable job control
control_c() {
        echo "....STOP"
        echo "----------EXIT----------"
        destroy_bin
        exit
}
trap control_c SIGINT SIGTERM

# Determine the system's root disk
#-=-
get_root_device(){
	df | grep "/$" | cut -d " " -f 1
}

#
 #####################
 # START CODE
 #####################
#
echo " __                          "
echo "|__)    _  | _  _     _  _|_ "
echo "|__)|_|_)\/|(_)(_).  | )(-|_ "
echo "         /     _/            "
echo "http://busylog.net           "
echo "-----------------------------"
echo "busyupload.sh V0.1"
echo "\|/"
echo "This is a early version with learning purpose... check the TODO"
echo "Some logs here: $FILE_LOG"
echo "-----------------------------"

#DEBUG
#test_speed "zgb-speedtest-1.tele2.net" "anonymous" "test@test.tst" "upload" "test"
#ftp_speed_hr "11257.46 Kbytes/sec"
#freegeoip_geolocation
#echo $OPENSSL;
#exit 1;

echo "-----------$(date)-----------" >>$FILE_LOG
check_what_we_can_do
echo "-----------------------------"
echo "Network upload test...."
if [[ -z $ISftp || -z $ISwget ]]; then
	echo "not performed tests.... test needs ftp and wget installed"
else
	#Generate 100MB tmp file do uplpad
	generate_bin 100
	echo "-----------------------------"
	echo "This server is located in :"$(freegeoip_geolocation)
	#Upload tmp file for each FTP server
	count=0;
	for ftp_host in ${FARM_FTP[@]}; do
		echo "-----------------------------"
		ftp_user=${FTP_USER[count]}
		ftp_pass=${FTP_PASS[count]} 
		ftp_fold=${FTP_FOLD[count]}
		ftp_note=${FARM_FTP_NOTE[count]}
		#DEBUG
		#echo "Target : HOST=$ftp_host / USER=$ftp_user / PASS=$ftp_pass / FOLDER=$ftp_fold / FILE=$file_name /MOTE=$ftp_note ..."
		echo "Upload $ftp_host -[ $ftp_note ]- located in: $(freegeoip_geolocation $ftp_host)"
		echo "Latency : "$(ftp_latency "$ftp_host")
		speed=$(test_speed $ftp_host $ftp_user $ftp_pass $ftp_fold $file_name)
		speedhr=$(ftp_speed_hr "$speed")
		echo "Upload speed : $speed ($speedhr)"
		count=$(( $count + 1 ))
	done
	
	destroy_bin
fi

echo "-----------------------------"
echo "Test openSSL speeds (openssl signatures speed)...."
if [[ -z $ISopenssl ]]; then
	echo "not performed tests.... test needs openssl installed"
else
	openssl speed rsa
fi

echo "-----------------------------"
echo "Disk seek rate test (ioping)...."
if [[ -z $ISioping ]]; then
	echo "not performed tests.... test needs ioping and wget installed"
else
	ioping -R .
fi

echo "-----------------------------"
echo "Direct (not cached) disk reads (hdparm)...."
if [[ -z $IShdparm ]]; then
	echo "not performed tests.... test needs hdparm installed"
else
	disk2test=$(get_root_device)
	echo "Test disk $disk2test"
	hdparm -t --direct $disk2test
fi



exit 0
