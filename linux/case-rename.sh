#!/usr/bin/env bash
find . -depth |while read LONG; do SHORT=$( basename "$LONG" | tr '[:upper:]' '[:lower:]' ); DIR=$( dirname "$LONG" ); if [ "${LONG}" != "${DIR}/${SHORT}"  ]; then mv "${LONG}" "${DIR}/${SHORT}" ; fi; done
