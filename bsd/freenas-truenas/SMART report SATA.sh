#!/bin/sh

### Parameters ###
logfile="/tmp/smart_report.tmp"
email="travisrunyard@gmail.com"
subject="SMART SATA Status Report for FreeNAS"
drives="da1 da2 da3 da4"
tempWarn=40
tempCrit=45
sectorsCrit=10
testAgeWarn=1
warnSymbol="?"
critSymbol="!"

### Set email headers ###
(
    echo "To: ${email}"
    echo "Subject: ${subject}"
    echo "Content-Type: text/html"
    echo "MIME-Version: 1.0"
    echo -e "\r\n"
) > "$logfile"

### Set email body ###
echo "<pre style=\"font-size:14px\">" >> "$logfile"

###### summary ######
(
    echo ""
    echo "########## SMART status report summary for all drives ##########"
    echo ""
    echo "+------+---------------+----+-----+-----+-----+-------+-------+--------+------+------+------+-------+----+"
    echo "|Device|Serial         |Temp|Power|Start|Spin |ReAlloc|Current|Offline |UDMA  |Seek  |High  |Command|Last|"
    echo "|      |               |    |On   |Stop |Retry|Sectors|Pending|Uncorrec|CRC   |Errors|Fly   |Timeout|Test|"
    echo "|      |               |    |Hours|Count|Count|       |Sectors|Sectors |Errors|      |Writes|Count  |Age |"
    echo "+------+---------------+----+-----+-----+-----+-------+-------+--------+------+------+------+-------+----+"
) >> "$logfile"
for drive in $drives
do
    (
        smartctl -A -i -v 7,hex48 /dev/"$drive" | \
        awk -v device="$drive" -v tempWarn="$tempWarn" -v tempCrit="$tempCrit" -v sectorsCrit="$sectorsCrit" \
        -v testAgeWarn="$testAgeWarn" -v warnSymbol="$warnSymbol" -v critSymbol="$critSymbol" \
        -v lastTestHours="$(smartctl -l selftest /dev/"$drive" | grep "# 1" | awk '{print $9}')" '\
        /Serial Number:/{serial=$3} \
        /Temperature_Celsius/{temp=$10} \
        /Power_On_Hours/{onHours=$10} \
        /Start_Stop_Count/{startStop=$10} \
        /Spin_Retry_Count/{spinRetry=$10} \
        /Reallocated_Sector/{reAlloc=$10} \
        /Current_Pending_Sector/{pending=$10} \
        /Offline_Uncorrectable/{offlineUnc=$10} \
        /UDMA_CRC_Error_Count/{crcErrors=$10} \
        /Seek_Error_Rate/{seekErrors=("0x" substr($10,3,4));totalSeeks=("0x" substr($10,7))} \
        /High_Fly_Writes/{hiFlyWr=$10} \
        /Command_Timeout/{cmdTimeout=$10} \
        END {
            testAge=sprintf("%.0f", (onHours - lastTestHours) / 24);
            if (temp > tempCrit || reAlloc > sectorsCrit || pending > sectorsCrit || offlineUnc > sectorsCrit)
                device=device " " critSymbol;
            else if (temp > tempWarn || reAlloc > 0 || pending > 0 || offlineUnc > 0 || testAge > testAgeWarn)
                device=device " " warnSymbol;
            seekErrors=sprintf("%d", seekErrors);
            totalSeeks=sprintf("%d", totalSeeks);
            if (totalSeeks == "0") {
                seekErrors="N/A";
                totalSeeks="N/A";
            }
            if (hiFlyWr == "") hiFlyWr="N/A";
            if (cmdTimeout == "") cmdTimeout="N/A";
            printf "|%-6s|%-15s| %s |%5s|%5s|%5s|%7s|%7s|%8s|%6s|%6s|%6s|%7s|%4s|\n",
            device, serial, temp, onHours, startStop, spinRetry, reAlloc, pending, offlineUnc, \
            crcErrors, seekErrors, hiFlyWr, cmdTimeout, testAge;
        }'
    ) >> "$logfile"
done
(
    echo "+------+---------------+----+-----+-----+-----+-------+-------+--------+------+------+------+-------+----+"
    echo ""
    echo ""
) >> "$logfile"

###### for each drive ######
for drive in $drives
do
    brand="$(smartctl -i /dev/"$drive" | grep "Model Family" | awk '{print $3, $4, $5}')"
    serial="$(smartctl -i /dev/"$drive" | grep "Serial Number" | awk '{print $3}')"
    (
        echo ""
        echo "########## SMART status report for ${drive} drive (${brand}: ${serial}) ##########"
        smartctl -H -A -l error /dev/"$drive"
        smartctl -l selftest /dev/"$drive" | grep "# 1 \|Num" | cut -c6-
        echo ""
        echo ""
    ) >> "$logfile"
done
sed -i '' -e '/smartctl 6.3/d' "$logfile"
sed -i '' -e '/Copyright/d' "$logfile"
sed -i '' -e '/=== START OF READ/d' "$logfile"
sed -i '' -e '/SMART Attributes Data/d' "$logfile"
sed -i '' -e '/Vendor Specific SMART/d' "$logfile"
sed -i '' -e '/SMART Error Log Version/d' "$logfile"
echo "</pre>" >> "$logfile"

### Send report ###
sendmail -t < "$logfile"
rm "$logfile"