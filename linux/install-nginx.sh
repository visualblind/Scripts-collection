#!/bin/bash

#####################################################################
#
# Copyright (C) Nginx, Inc.
#
# Author:  Rick Nelson, NGINX Inc.
# Version: 0.8.1
# Date:    2016-03-29
#
# This script will install the latest version of NGINX Plus on Ubuntu,
# Debian, RedHat, CentOS, Oracle Linux, Amazon Linux, Suse or FreeBSD.
# It must be run as root.
#
# For trial users, they can enter their token on the command line or
# at a prompt and their cert and key will be downloaded before the
# installation is done. The script can also be used without a token if
# the user installs their cert and key in /etc/ssl/nginx.
#
# Note: wget and bash version 4 are required by this script, so the
# script checks to make sure they are installed. This is mostly an
# issue with FreeBSD and lean installs of Linux.  For Ubuntu and Debian
# lsb_release is also required, so that is checked as well.
#
# This script does the following:
#
# 1. The OS and version will be checked to see if they are supported and
#    have all the prerequisites.
# 2. If the user did not enter a token on the command line, they will be
#    prompted for a token.
# 3. If a token was entered, it will be used to download the cert and key
#    to /etc/ssl/nginx.
# 4. The cert and key directory (/etc/ssl/nginx) is checked to make sure that
#    it contains nginx-repo.crt and nginx-repo.key.
# 5. The expiration date of the certificate will be checked to make
#    sure it hasn't expired. If a token is used, then the certificate
#    should always have a valid date.
# 6. NGINX Plus is installed.
#
# The supported operating systems are:
#    Ubuntu 12.04, 14.04, 15.10, 16.04
#    Debian 7.0, 8.0
#    RedHat, CentOS, Oracle Linux 6.5+, 7.0+
#    Suse 12
#    FreeBSD 10.3, 11.0+
#
# Note: We avoid setting global variables in functions.  For
#       functions that don't print anything to the user we use
#       command subsitition and write the return value to stdout.
#       For functions that do print text to the user we pass in
#       the value to be set and use eval.
#####################################################################

#####################################################################
# Function checkOSPrereqs
#
# Check to make sure that this script is being run using bash version
# 4 and that wget and sudo are installed
#
# Return: 0 for success, 1 for error
#####################################################################
checkOSPrereqs () {

    rc=0

    n=`echo $BASH_VERSION | awk -F. '{print $1}'`
    if [ ! "$n" = 4 ]; then
        echoErr "Error: This script must be run with bash version 4";
        rc=1
    fi

    n=`wget -V 2>&1 | grep "GNU Wget"`
    if [ -z "$n" ]; then
        echoErr "Error: wget not found in path.  It must be installed"\
        "to run this script"
        rc=1
    fi

    #n=`sudo -V 2>&1 | grep "Sudo version"`
    #if [ -z "$n" ]; then
    #    echoErr "Error: sudo not found in path.  It must be installed"\
    #    "to run this script"
    #    rc=1
    #fi

    return $rc
}

#####################################################################
# Function checkLSBRelease
#
# Check to make sure that lsb_release is installed
#
# Return: 0 for success, 1 for error
#####################################################################
XcheckLSBRelease () {

    rc=0

    n=`lsb_release -i 2>&1 | grep "Distributor"`
    if [ -z "$n" ]; then
        echoErr "Error: lsb_release not found in path.  It must be installed"\
        "to run this script"
        rc=1
    fi

    return $rc
}

#####################################################################
# Function getOS
#
# Getting the OS is not the same on all distributions.  First we use
# uname to find out if we are running on Linux or FreeBSD. For all the
# supported versions of Debian and Ubuntu we expect to find the
# /etc/os-release file which has multiple lines with name value pairs
# from which we can get the OS name and version. For RedHat and its
# varients, the os-release file may or may not exist, depending on the
# version.  If it doesn't, then we expect to find the etc/redhat-release
# file which has one line from which we get the OS and version. For
# FreeBSD we use the "uname -rs" command.
#
# A string is written to stdout with three values separated by ":":
#    OS
#    OS Name
#    OS Version
#
# If none of these files was found, an empty string is written.
#
# Return: 0 for success, 1 for error
#####################################################################
getOS () {

    local os=""
    local osName=""
    local osVersion=""
    local releaseText=""

    os=`uname | tr [:upper:] [:lower:]`

    if [ "$os" != "$LINUX" ] && [ "$os" != "$FREEBSD" ]; then
        echoErr "Error: Operating system is not Linux or FreeBSD"
        echo
        return 1
    fi
    if [ "$os" = "linux" ]; then
        if [ -f $osRelease ]; then
            # The value for the ID and VERSION_ID may or may not be in quotes
            osName=`cat $osRelease | grep "^ID=" | sed s/\"//g | awk -F= '{ print $2 }'`
            osVersion=`cat $osRelease | grep "^VERSION_ID=" | sed s/\"//g | awk -F= '{ print $2 }'`
        else
            if [ -f $redhatRelease ]; then
                releaseText=`cat $redhatRelease`
            else
                echoErr "Error: Unable to determine operating system and version"
                echo
                return 1
            fi
            # We get the first word which should be either "Red" or "CentOS".
            # If it is "Red" then the version will be the 7th word and if it
            # is "CentOS" then the version will be the 4th word.
            first=`echo $releaseText | awk '{print $1}'`
            if [ "$first" = "Red" ]; then
                osName=$REDHAT
                osVersion=`echo $releaseText | awk '{print $7}'`
            else
                osName=$CENTOS
                osVersion=`echo $releaseText | awk '{print $3}'`
            fi
            if [ ! "$osName" ] || [ ! "$osVersion" ]; then
                echoErr "Operating system and/or version not found in $redhatRelease: $releaseText"
                echo
                return 1
            fi
        fi
    else
        osName=$os
        osVersion=`uname -rs | awk -F '[ -]' '{print $2}'`
        if [ -z $osVersion ]; then
            echoErr "Unable to get FreeBSD version"
            echo
            return 1
        fi
    fi

    # Force osName to lowercase
    osName=`echo $osName | tr [:upper:] [:lower:]`
    echoDebug "getOS: os=$os osName=$osName osVersion=$osVersion"
    echo "$os:$osName:$osVersion"

    return 0
}

#####################################################################
# Function checkOS
#
# Check if the OS and version are supported
#
# 2 parameters should be passed in, osName and osVersion
#
# Return: 0 for success, 1 for error
#####################################################################
checkOS () {

    local osName=$1
    local osVersion=$2

    if [ -n "$osName" ]; then
        if ! `echo ${supportedOSDist[@]} | grep -wq "$osName"`; then
            echoErr "Error: Operating System $osName is not supported"
            return 1
        fi
    else
        echoErr "Error: Operating System name is not set"
        return 1
    fi

    # Check the OS Version
    if [ -z "$osVersion" ]; then
        echoErr "Error: Operating System Version is not set"
        return 1
    fi
    if [[ $osVersion =~ ${osCheckVersion[$osName]} ]]; then
        return 0
    else
        echoErr "Error: Version $osVersion of $osName is not supported"
        echoErr "Supported versions: ${osSupportedVersion[$osName]}"
        return 1
    fi
}

#####################################################################
# Function checkToken
#
# Return: 0 for success, 1 for error
#####################################################################
checkToken() {

    if [[ "$1" =~ [a-f|0-9]{32,32}$ ]]; then
        echoDebug "checkToken: Matched"
        return 0
    else
        echoErr "Token $1 is invalid"
        return 1
    fi
}

#####################################################################
# Function getToken
#
# Prompt the user for the trial token.  The variable to set with the
# token value is passed as an argument.
#####################################################################
getToken () {

    local __token=$1
    local myToken

    while [ :: ]; do
        echo
        echo "Please enter your trial token.  This will allow the"
        echo "certificate and key to be downloaded that are required"
        echo "to access the NGINX Plus repository."
        echo
        echo "***************************************************************"
        echo "* Note: The certificate and key can only be downloaded once.  *"
        echo "*       This script will download them to /etc/ssl/nginx.     *"
        echo "*       If you need to do additional installations, copy      *"
        echo "*       nginx-repo.crt and nginx-repo.key to the new server.  *"
        echo "***************************************************************"
        echo
        echo "If you do not have the token or it has already been used,"
        echo "leave it blank and put the nginx-repo.crt and nginx-repo.key"
        echo "files into /etc/ssl/nginx."
        echo
        echo -en "Trial token: "
        read myToken
        if [ -z $myToken ] || checkToken $myToken; then
            break;
        fi
    done

    eval $__token="'$myToken'"
    return 0
}

#####################################################################
# Function getCertAndKey
#
# This function will download the nginx-repo.crt and nginx-repo.key
# files to the /etc/ssl/nginx directory.
#
# Note: For some reason FreeBSD is rejecting the cert for cs.nginx.com
#       and requires --no-check-certificate.
#
# Input: The trial token
#
# Return: 0 for success, 1 for error
#####################################################################
getCertAndKey () {

    token=$1

    if [ ! -d "$crtKeyPath" ]; then
        mkdir -p $crtKeyPath
    fi

    certLink="https://cs.nginx.com/otl/$token/cert"
    keyLink="https://cs.nginx.com/otl/$token/private_key"

    wget -nv --no-check-certificate -O $crtKeyPath/nginx-repo.crt $certLink
    # Check that the file exist and is not empty
    if [ -f $crtKeyPath/nginx-repo.crt ] && [ -s $crtKeyPath/nginx-repo.crt ]; then
        wget -nv --no-check-certificate -O $crtKeyPath/nginx-repo.key $keyLink
        if [ -f $crtKeyPath/nginx-repo.key ] && [ -s $crtKeyPath/nginx-repo.key ]; then
            echoDebug "getCertAndKey: Cert and key downloaded"
            return 0
        else
            echoErr -e "\nError downloading nginx-repo.key"
            return 1
        fi
    else
        echoErr -e "\nError downloading nginx-repo.crt"
        return 1
    fi
}

#####################################################################
# Function checkCertKey
#
# Check that the cert and key exist and that the cert hasn't expired
#
# Return: 0 for success, 1 for error
#####################################################################
checkCert() {

    certFile="$1/nginx-repo.crt"
    keyFile="$1/nginx-repo.key"

    if [ ! -f "$certFile" ]; then
        echoErr "Error: $certFile does not exist"
        return 1
    fi
    if [ ! -f "$keyFile" ]; then
        echoErr "Error: $keyFile does not exist"
        return 1
    fi

    endDate=`openssl x509 -enddate -in $certFile -noout 2>/dev/null`
    if [ ! "$endDate" ]; then
        echoErr "Error getting end date from certificate $certFile"
        return 1
    fi
    endDate=`echo $endDate | sed 's/.*=//'`

    # The date command works differently on Linux versus FreeBSD
    if [ "$os" = "$LINUX" ]; then
        endDate=`LC_TIME=C date -d "$endDate" +%s` || return 1
    else
        endDate=`date -j -f "%b %d %T %Y %Z" "$endDate" +%s` || return 1
    fi
    curDate=`date +%s`

    case "$endDate$curDate" in
        ''|*[!0-9]*)
           echoErr "Error with certificate end date or current date"
           return 1
           ;;
    esac

    if [ $curDate -gt $endDate ]; then
        echoErr "Your certificate has expired"
        return 1
    fi

    echoDebug "checkCert: Cert OK"

    return 0
}

#####################################################################
# Function installDebian
#####################################################################
installDebian () {

    echoDebug "Install on Debian"

    wget -q -O /var/tmp/nginx_signing.key http://nginx.org/keys/nginx_signing.key && apt-key add /var/tmp/nginx_signing.key
    wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx

    apt-get install apt-transport-https lsb-release ca-certificates

    printf "deb https://plus-pkgs.nginx.com/debian `lsb_release -cs` nginx-plus\n" |
           tee /etc/apt/sources.list.d/nginx-plus.list

    apt-get update
    apt-get install -y $NGINXPLUS

    return 0
}

#####################################################################
# Function installUbuntu
#####################################################################
installUbuntu () {

    echoDebug "Install on Ubuntu"

    apt-get update

    #if [ "$osVersion" = "15.10" ]; then
    #    apt-get install -y apt-transport-https
    #else
    #    apt-get install -y apt-transport-https libgnutls26 libcurl3-gnutls
    #fi
    apt-get install apt-transport-https lsb-release ca-certificates

    wget -q -O /var/tmp/nginx_signing.key http://nginx.org/keys/nginx_signing.key && apt-key add /var/tmp/nginx_signing.key
    wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx

    printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" >\
           /etc/apt/sources.list.d/nginx-plus.list

    apt-get update
    apt-get install -y $NGINXPLUS

    return 0
}

#####################################################################
# Function checkGeoIP
#
# Some version of RedHat/CentOS may not have GeoIP installed or the
# epel repo setup so that the NGINX Plus install can install it.
#
# Return: 0 for success, 1 for error
#####################################################################
XcheckGeoIP () {

    # If GeoIP is installed then we expect to find the string
    # "Name : GeoIP" on two lines.  We will look for the first.
    n=`yum -e0 -q info GeoIP | grep Name | awk -F: 'NR==1{print $2}'`

    if [ "$n" = " GeoIP" ]; then
        return 0
    else
        # Check that the epel repo is available
        n=`yum repolist | grep epel`
        if [ -n "$n" ]; then
            return 0
        else
            return 1
        fi
    fi
}

#####################################################################
# Function installRedHat
#####################################################################
installRedHat () {

    echoDebug "Install on RedHat/CentOS/Oracle"


    release=`expr "$osVersion" : $majorVersionRegex`
    repo="nginx-plus-$release.repo"

    wget -q -O /etc/yum.repos.d/$repo https://cs.nginx.com/static/files/$repo

    yum install -y $NGINXPLUS

    return 0
}

#####################################################################
# Function installAmazon
#####################################################################
installAmazon () {

    echoDebug "Install on Amazon"


    wget -q -O /etc/yum.repos.d/nginx-plus-amazon.repo https://cs.nginx.com/static/files/nginx-plus-amazon.repo

    yum install -y $NGINXPLUS

    return 0
}

#####################################################################
# Function installSuse
#####################################################################
installSuse () {

    echoDebug "Install on Suse"


    cat /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key >\
        /etc/ssl/nginx/nginx-repo-bundle.crt

    zypper addrepo -G -t yum -c 'https://plus-pkgs.nginx.com/sles/12?ssl_clientcert=/etc/ssl/nginx/nginx-repo-bundle.crt&ssl_verify=host' nginx-plus

    zypper install $NGINXPLUS

    return 0
}

#####################################################################
# Function installFreeBSD
#####################################################################
installFreeBSD () {

    echoDebug "Install on FreeBSD"

    # Some instances of FreeBSD are not accepting the cs.nginx.com cert
    wget --no-check-certificate -O /etc/pkg/nginx-plus.conf http://cs.nginx.com/static/files/nginx-plus.conf

    # It is possible that the script has been run before so, only add
    # the lines if they aren't already there.
    n=`grep "nginx-repox.crt" /usr/local/etc/pkg.conf`
    if [ -z "$n" ]; then
        echo 'PKG_ENV: { SSL_NO_VERIFY_PEER: "1", SSL_CLIENT_CERT_FILE: '\
             '"/etc/ssl/nginx/nginx-repo.crt", SSL_CLIENT_KEY_FILE: '\
             '"/etc/ssl/nginx/nginx-repo.key" }' >> /usr/local/etc/pkg.conf
    fi
    pkg install $NGINXPLUS

    return 0
}

#####################################################################
# Function am_i_root
#####################################################################
am_i_root() {

    USERID=`id -u`
    if [ 0 -ne $USERID ]; then
        echoErr "This script requires root privileges to run, exiting."
        exit 1
    fi

    return 0
}

#####################################################################
# Function echoErr
#
# Echo a string to stderr
#####################################################################
echoErr () {

    echo "$*" 1>&2;
}

#####################################################################
# Function echoDebug
#
# Echo a string to stderr if $debug=1
#####################################################################
echoDebug () {

    if [ $debug -eq 1 ]; then
        echo "$@" 1>&2;
    fi
}

#####################################################################
#####################################################################
## Main
#####################################################################
#####################################################################
debug=0 # If set to 1, debug message will be displayed

if ! checkOSPrereqs; then
    exit 1
fi

crtKeyPath="/etc/ssl/nginx"

# The name and location of the files that will be used to get Linux
# release info
osRelease="/etc/os-release"
redhatRelease="/etc/redhat-release"

LINUX="linux"

AMAZON="amzn"
CENTOS="centos"
DEBIAN="debian"
FREEBSD="freebsd"
ORACLE="ol" # Note: for early versions that don't have the /etc/os-release
            # file, the value in the /etc/redhat-release file will be "Red Hat"
REDHAT="rhel"
SUSE="sles"
UBUNTU="ubuntu"

NGINXPLUS="nginx-plus"

declare -a supportedOSDist=($UBUNTU $DEBIAN $REDHAT $CENTOS $ORACLE $SUSE $FREEBSD $AMAZON)

# The following are used for error messages
declare -A osSupportedVersion=([$UBUNTU]='12.04, 14.04, 15.10 and 16.04'
                               [$DEBIAN]='7 and 8'
                               [$REDHAT]='6.5+ and 7+'
                               [$CENTOS]='6.5+ and 7+'
                               [$ORACLE]='6.5+ and 7+'
                               [$AMAZON]='2016.03+'
                               [$SUSE]='12'
                               [$FREEBSD]='10.3, 11')

# These regexs check the version and verify that the version starts with
# a valid value.  It does not check that the following characters are
# valid for a release
declare -A osCheckVersion=([$UBUNTU]='(12.04|14.04|15.10|16.04).*$'
                          [$DEBIAN]='(7|8).*$'
			  [$REDHAT]='(6.[5-9]{1}|6.1[0-9]{1}|7).*$'
                          [$CENTOS]='(6.[5-9]{1}|6.1[0-9]{1}|7).*$'
                          [$ORACLE]='(6.[5-9]{1}|6.1[0-9]{1}|7).*$'
                          [$AMAZON]='(201[6-9]{1}.0[39]{1}.*$)'
                          [$SUSE]='(12).*$'
                          [$FREEBSD]='(10.3|11).*$')

# regex to extract the RHEL/CentOS release from /etc/redhat-release
# for version that don't have /etc/os-release. For these version of
# RedHat we expect the string to be like:
#     Red Hat Enterprise Linux Server release 7.1 (Maipo)
# And for CentOS to be like:
#     CentOS release 6.7 (Final)
# And for RedHat we set the osName to "rhel" ($REDHAT).

# regex to extract the first digit of the RHEL/CentOS version.
# This is to know which nginx-plus-x-repo file to download
majorVersionRegex='\([67]\).*$'

os="" # Will be "linux" or "freebsd"
osName="" # Will be "ubuntu", "debian", "rhel",
          # "centos", "suse", "amzn" or "freebsd"
osVersion=""

today=`date +"%Y%m%d"`

token=""

am_i_root

echo
echo "This script will install NGINX Plus"

# Check the OS
osNameVersion=$(getOS)
if [ -z osNameVersion ]; then
    echoErr "Error getting the operating system information"
    exit 1
fi

# Breakout the OS, name and version
os=`echo $osNameVersion | awk -F: '{print $1}'`
osName=`echo $osNameVersion | awk -F: '{print $2}'`
osVersion=`echo $osNameVersion | awk -F: '{print $3}'`

if ! checkOS "$osName" "$osVersion"; then
    echoErr "Main: osVersion is not supported"
    exit 1
fi

# The token can be passed as an argument, if not, prompt for it
if [ -n "$1" ]; then
    if checkToken "$1"; then
        token=$1
    fi
fi
if [ -z "$token" ]; then
    getToken token
fi

while [ :: ]; do
    echo -en "\nDo you want to install $NGINXPLUS for $osName $osVersion? [y/n]: "
    read response
    case "$response" in
        y|Y)
            break
            ;;
        n|N)
            echo
            exit 1
            ;;
        *)
            echo "Please use 'y' or 'n'"
            ;;
    esac
done

if [ -n "$token" ]; then
    # Download the cert and key
    if ! getCertAndKey $token; then
        exit 1
    fi
fi

if ! checkCert $crtKeyPath; then
    exit 1
fi

# Call the appropriate installation function
case "$osName" in
    $DEBIAN)
        installDebian
        ;;
    $UBUNTU)
        installUbuntu
        ;;
    $REDHAT | $CENTOS | $ORACLE)
        installRedHat
        ;;
    $AMAZON)
        installAmazon
        ;;
    $SUSE)
        installSuse
        ;;
    $FREEBSD)
        installFreeBSD
        ;;
esac
