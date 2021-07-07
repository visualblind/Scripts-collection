#!/bin/bash
VERSION=$(freebsd-version | sed 's|STABLE|RELEASE|g')
declare -a vars
eval "vars=(`/usr/local/bin/iocage list | awk '{ print $4 }' | sed '2d' | grep .`)"
for ((I = 0; I < ${#vars[@]}; ++I )); do
	/usr/local/bin/iocage update "${vars[$I]}"
	/usr/local/bin/iocage upgrade "${vars[$I]}" -r "$VERSION"
	  if /usr/local/bin/iocage exec "${vars[$I]}" "pkg update && pkg upgrade" | grep -q 'Your packages are up to date.'; then
		echo "No need to restart jails"
	  else
		/usr/local/bin/iocage restart "${vars[$I]}"
	  fi
done
