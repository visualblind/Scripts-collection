#!/bin/bash
#
set -o nounset
set -o errexit

# Ensure superuser privileges, if required
[[ $EUID -ne 0 ]] && {
	printf '%s\n' 'Must be run as superuser' >&2
	exit 1
}

# install the executable
cd /usr/local/bin/
wget -N https://git.launchpad.net/linux-purge/plain/linux-purge
chmod +x linux-purge

# install manual page
mandir=/usr/local/man/man8
mkdir -p "$mandir"
cd "$mandir"
wget -N https://git.launchpad.net/linux-purge/plain/doc/linux-purge.8
gzip -f linux-purge.8
mandb -q

# install Bash completion
compdir=/usr/share/bash-completion/completions # for Ubuntu 16.04 and older
dpkg --compare-versions $(dpkg-query -W -f'${Version}\n' bash-completion) ge '1:2.2' \
&& {
	rm -f "$compdir"/linux-purge # delete possible old file
	compdir=/usr/local/share/bash-completion/completions
	mkdir -p "$compdir"
}
cd "$compdir"
wget -N https://git.launchpad.net/linux-purge/plain/completions/bash/linux-purge
