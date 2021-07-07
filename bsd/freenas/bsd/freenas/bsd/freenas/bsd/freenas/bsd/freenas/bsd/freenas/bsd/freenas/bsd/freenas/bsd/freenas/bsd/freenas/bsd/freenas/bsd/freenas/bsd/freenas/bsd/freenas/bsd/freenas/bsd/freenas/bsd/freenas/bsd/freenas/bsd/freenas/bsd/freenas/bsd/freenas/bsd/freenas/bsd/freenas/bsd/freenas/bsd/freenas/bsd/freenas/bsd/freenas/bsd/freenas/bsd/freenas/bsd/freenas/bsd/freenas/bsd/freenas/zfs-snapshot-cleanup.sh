#!/usr/bin/env bash

for arg in "$@"
do
case $arg in
    --dataset=*)
    DATASET="${arg#*=}"
    shift
    ;;
    --keepdays=*)
    KEEPDAYS="${arg#*=}"
    shift
    ;;
    --quiet)
    QUIET="TRUE"
    shift
    ;;
    --dry-run)
    DRYRUN="TRUE"
    shift
    ;;
    *)
    ;;
esac
done

if [[ $DATASET == '' ]]
then
    echo "--dataset parameter must be set"
        exit 1
fi

if [[ ! $KEEPDAYS =~ ^[0-9]+$ ]]
then
    echo "--keepdays parameter must be an integer"
        exit 1
fi

SKIPFILESYSTEMREGEX='.system|/sys/swap'
SNAPSHOTSTODELETE=''
FROMDATE=$(date -j -f "%Y-%m-%d %H:%M:%s" "1970-01-01 00:00:00" +"%s")
TODATE=$(date -n -v -${KEEPDAYS}d +"%s")

FILESYSTEMS=$(zfs list -t filesystem -o name | grep $DATASET | egrep -v $SKIPFILESYSTEMREGEX | sort)

for FILESYSTEM in $FILESYSTEMS
do
    for SNAPSHOT in $(zfs list -r -t snapshot -o name -S creation $FILESYSTEM | tail -n +2 | grep $FILESYSTEM@ | grep auto)
    do
        SNAPSHOTDATE=$(date -j -f "%a %b %d %H:%M %Y" "$(zfs list -r -t snapshot -o creation $SNAPSHOT | tail -n +2)" +"%s")
        if ((SNAPSHOTDATE >= $FROMDATE && SNAPSHOTDATE <= $TODATE))
        then
            SNAPSHOTSTODELETE+="$SNAPSHOT "
        fi
    done
done

if [[ ! $SNAPSHOTSTODELETE == '' ]]
then
    if [[ $QUIET == 'TRUE' ]]
    then
        for SNAPSHOT in $SNAPSHOTSTODELETE
        do
            zfs destroy -vn $SNAPSHOT
        done
    else
        for SNAPSHOT in $SNAPSHOTSTODELETE
        do
            echo "$SNAPSHOT"
        done
        echo
        read -p "Are you sure you want to delete the above snapshots? " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            for SNAPSHOT in $SNAPSHOTSTODELETE
            do
                echo "zfs destroy $SNAPSHOT"
                zfs destroy -vn $SNAPSHOT
            done
        fi
    fi
fi