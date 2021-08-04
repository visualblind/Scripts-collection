#!/usr/bin/env bash

# example: ./bashre_id3v2.sh '([0-9]{,2})' '/media/mp3'

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 PATTERN DIRECTORY"
    exit 1
fi

regex="$1"
cd "$2" || { echo "Error: could not find directory, exiting..."; exit 1; }

for f in *.mp3
do
  if [[ -f "$f" ]]; then
    echo -e ">>> $f\nChecking if it matches the regex: $regex"
    if [[ "$f" =~ $regex ]]; then
      n=${BASH_REMATCH[0]}
      echo -e "Capture group: '$n' in the file $f\nStarting id3v2..."
      id3v2 --track "$n" "$f"
      echo -e "id3v2 track tag: $n was written successfully\n"
    fi
  else
    echo ">>> '$f' not found, exiting..."
    exit 1
  fi
done
echo "##### Script completed successfully #####"