#!/usr/bin/env sh

case "$OSTYPE" in
  solaris*) echo "SOLARIS" ;;
  darwin*)  echo "OSX" ;; 
  linux*)   echo "LINUX" ;;
  *bsd*)     echo "BSD" ;;
  msys*)    echo "WINDOWS" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac


# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    echo "LINUX"
    alias ls='ls --color=auto'
    ;;
  'FreeBSD')
    OS='FreeBSD'
    echo "BSD"
    alias ls='ls -G'
    ;;
  'WindowsNT')
    OS='Windows'
    echo "WINDOWS"
    ;;
  'Darwin') 
    OS='Mac'
    echo "OSX"
    ;;
  'SunOS')
    OS='Solaris'
    echo "SOLARIS"
    ;;
  'AIX') 
	echo "AIX"
	;;
  *) ;;
esac