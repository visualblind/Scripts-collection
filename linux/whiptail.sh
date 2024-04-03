#!/usr/bin/env bash

# Explanation of 3>&1 1>&2 2>&3 file descriptors:
# 1) Create a file descriptor 3 that points to 1 (stdout)
# 2) Redirect 1 (stdout) to 2 (stderr)
# 3)  Redirect 2 (stderr) to the 3 file descriptor, which is pointed to stdout

NAME=$(whiptail --inputbox "What is your name?" 8 39 --title "Getting to know you" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
	echo "Greetings," $NAME
else
	echo "User canceled input."
fi

echo "(Exit status: $exitstatus)"

if (whiptail --title "Is it Tuesday?" --yesno "Is today Tuesday?" 8 78); then
	echo "Happy Tuesday, exit status was $?."
else
	echo "Maybe it will be Tuesday tomorrow, exit status was $?."

fi
