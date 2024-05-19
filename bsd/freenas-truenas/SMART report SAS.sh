#!/bin/sh

### Parameters ###
logfile="/tmp/smart_report.tmp"
email="travisrunyard@gmail.com"
subject="SMART SAS Status Report for FreeNAS"
drives="da5 da6"
tempWarn=40
tempCrit=45
warnSymbol="?"
critSymbol="!"

### Set email headers ###
(
    echo "To: ${email}"
    echo "Subject: ${subject}"
    echo "Content-Type: text/html"
    echo "MIME-Version: 1.0"
    echo -e "\r\n"
) > ${logfile}

### Set email body ###
echo "<pre style=\"font-size:14px\">" >> ${logfile}

###### summary ######
(
    echo ""
    echo "########## SMART status report summary for all drives ##########"
    echo ""
    echo "+------+---------------+----+-----+------+------+------+------+------+------+"
    echo "|Device|Serial         |Temp|Start|Load  |Defect|Uncorr|Uncorr|Uncorr|Non   |"
    echo "|      |               |    |Stop |Unload|List  |Read  |Write |Verify|Medium|"
    echo "|      |               |    |Count|Count |Elems |Errors|Errors|Errors|Errors|"
    echo "+------+---------------+----+-----+------+------+------+------+------+------+"
) >> ${logfile}
for drive in $drives
do
    (
        smartctl -a /dev/${drive} | \
        awk -v device=${drive} -v tempWarn=${tempWarn} -v tempCrit=${tempCrit} \
        -v warnSymbol=${warnSymbol} -v critSymbol=${critSymbol} '\
        /Serial number:/{serial=$3} \
        /Current Drive Temperature:/{temp=$4} \
        /start-stop cycles:/{startStop=$4} \
        /load-unload cycles:/{loadUnload=$4} \
        /grown defect list:/{defectList=$6} \
        /read:/{readErrors=$8} \
        /write:/{writeErrors=$8} \
        /verify:/{verifyErrors=$8} \
        /Non-medium error count:/{nonMediumErrors=$4} \
        END {
            if (temp > tempCrit)
                device=device " " critSymbol;
            else if (temp > tempWarn)
                device=device " " warnSymbol;
            printf "|%-6s|%-15s| %s |%5s|%6s|%6s|%6s|%6s|%6s|%6s|\n",
            device, serial, temp, startStop, loadUnload, defectList, \
            readErrors, writeErrors, verifyErrors, nonMediumErrors;
        }'
    ) >> ${logfile}
done
(
    echo "+------+---------------+----+-----+------+------+------+------+------+------+"
    echo ""
    echo ""
) >> ${logfile}

###### for each drive ######
for drive in $drives
do
    serial=`smartctl -i /dev/${drive} | grep "Serial number" | awk '{print $3}'`
    (
        echo ""
        echo "########## SMART status report for ${drive} drive (${serial}) ##########"
        smartctl -a /dev/${drive}
        echo ""
        echo ""
    ) >> ${logfile}
done
sed -i '' -e '/smartctl 6.3/d' ${logfile}
sed -i '' -e '/Copyright/d' ${logfile}
sed -i '' -e '/Compliance/d' ${logfile}
sed -i '' -e '/LU is resource/d' ${logfile}
sed -i '' -e '/Form Factor/d' ${logfile}
sed -i '' -e '/Logical Unit/d' ${logfile}
sed -i '' -e '/Device type/d' ${logfile}
sed -i '' -e '/Local Time/d' ${logfile}
sed -i '' -e '/SMART support/d' ${logfile}
sed -i '' -e '/Temperature Warning/d' ${logfile}
sed -i '' -e '/=== START OF/d' ${logfile}
sed -i '' -e '/SMART Attributes Data/d' ${logfile}
sed -i '' -e '/Drive Trip/d' ${logfile}
sed -i '' -e '/Manufactured/d' ${logfile}
sed -i '' -e '/Specified cycle count/d' ${logfile}
sed -i '' -e '/Specified load-unload/d' ${logfile}
sed -i '' -e '/Vendor/d' ${logfile}
sed -i '' -e '/Error counter/d' ${logfile}
sed -i '' -e '/SMART Self-test/d' ${logfile}
echo "</pre>" >> ${logfile}

### Send report ###
sendmail -t < ${logfile}
rm ${logfile}