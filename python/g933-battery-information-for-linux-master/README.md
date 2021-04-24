#The propper way to do it:
You can use https://github.com/Sapd/HeadsetControl to read battery information on multiple Logitech headsets. Other useful information https://github.com/pwr-Solaar/Solaar/issues/272

# G933-battery-information-script-for-linux
Using the script:
Python script to get battery information of a Logitech G933 headset on linux without Logitech Gaming Software

#NO WARRANTY#

Work in progress. Battery levels are not accurate yet > mostly guesses based on logged values

Currently disconnects audio during the operation for under second. Might be possible to avoid in the future

Writen using Python3, uses pyusb python package

REQUIRES SU for the usb communication

Usage: "sudo python3 g933battery.py"

Returns: "Battery:~86% (estimated from:2/2,151/255) Status: Idle"
