#!/bin/bash
 
#Use smartctl to get Serial Number - else dmesg is used
USESMART=0
#save glabel status to temporary file
CACHEGLABEL=1
 
if  [ $CACHEGLABEL -eq 0 ]
then
GLCMD="glabel status"
else
GLTMP=/var/tmp/$0.glabel
glabel status > $GLTMP
GLCMD="cat $GLTMP"
fi
 
ADALOW=`ls /dev/ada[0-9] 2>/dev/null`
ADAHIGH=`ls /dev/ada[0-9][0-9] 2>/dev/null`
DALOW=`ls /dev/da[0-9] 2>/dev/null`
DAHIGH=`ls /dev/da[0-9][0-9] 2>/dev/null`
#check if all device nodes exist or skip
if  [[ $ADALOW == *ls* ]]
then
$DALOW=
fi
if  [[ $ADAHIGH == *ls* ]]
then
$ADAHIGH=
fi
if  [[ $DALOW == *ls* ]]
then
$DALOW=
fi
if  [[ $DAHIGH == *ls* ]]
then
$DAHIGH=
fi
for FILE in $ADALOW $ADAHIGH $DALOW $DAHIGH
do
DEV=${FILE##'/dev/'}
#echo -n "${DEV}: "
if  [ $USESMART -eq 0 ]
then
SERIAL=`grep $DEV: /var/log/dmesg.today |grep -i Serial | awk '{print $(NF)}'`
else
SERIAL=`smartctl -a $FILE | grep -i 'Serial Number'| awk '{print $(NF)}'`
fi
#this skips all ufs drives
GPTID=`$GLCMD |grep 2$ |grep ${DEV}p|cut -d' ' -f1`
if [ "${GPTID}x" == 'x' ]
then
GPTID="No GPTID"
fi
if [ "${SERIAL}x" == 'x' ]
then
SERIAL="Not found"
fi
echo  ${DEV}: Serial $SERIAL \; GPTID=$GPTID
done
 
if  [ $CACHEGLABEL -eq 1 ]
then
rm $GLTMP
fi
