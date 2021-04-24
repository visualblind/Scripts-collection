#!/bin/bash -e

# Set default variable values
: ${SWAP_SIZE_MEGABYTES:=1024}
: ${SWAP_FILE_LOCATION:=/var/swap.space}

if (( $SWAP_SIZE_MEGABYTES <= 0 )); then
    echo 'No swap size provided, exiting.'
    exit 1
elif [ -e "$SWAP_FILE_LOCATION" ]; then
    echo "$SWAP_FILE_LOCATION" already exists,  skipping.  
fi

if ! swapon -s | grep -qF "$SWAP_FILE_LOCATION"; then
    echo Creating "$SWAP_FILE_LOCATION", "$SWAP_SIZE_MEGABYTES"MB.
    dd if=/dev/zero of="$SWAP_FILE_LOCATION" bs=1024 count=$(($SWAP_SIZE_MEGABYTES*1024))
    mkswap "$SWAP_FILE_LOCATION"    
    swapon "$SWAP_FILE_LOCATION"
    echo 'Swap status:'
    swapon -s
else
    echo Swap "$SWAP_FILE_LOCATION" file already on.
fi

echo 'Done.' 