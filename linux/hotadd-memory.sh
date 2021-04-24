for RAM in $(grep line /sys/devices/system/memory/*/state)
do
        echo "Found ram: ${RAM} ..."
        if [[ "${RAM}" == *":offline" ]]; then
                echo "Bringing online"
                echo $RAM | sed "s/:offline$//"|sed "s/^/echo online > /"|source /dev/stdin
        else
                echo "Already online"
        fi
done