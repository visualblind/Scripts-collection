#!/usr/bin/env sh
#
# Place this in /conf/base/etc/ in order to have it after a reboot.
# Call: sh chkidle.sh /dev/ada0
# switch1 is the drive to check (passed parameter)
switch1=$1

### Run SMART Check
testidle()
{
smartctl -a -n standby ${switch1} > /var/tempfile

# If chkdrive returns a value 2 for sleeping
if [ $? -eq "2" ]
then
echo "${switch1} Drive is Idle."
#rm /var/tempfile
return 0
fi

# if drive returns a value other than 0, error.
if [ $? -ne "0" ]
then
echo "****************"
echo "There is a drive error.  Check your ${switch1} drive for proper operation."
echo "****************"
return 0
fi
echo "${switch1} Drive is Not Idle."
}

# Lets test the drive

echo "Checking your drive..."
  testidle

# Cleanup our tiny mess
  rm /var/tempfile

exit 0
