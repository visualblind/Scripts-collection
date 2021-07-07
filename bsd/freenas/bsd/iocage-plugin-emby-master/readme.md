Emby Server for FreeNAS

Requires FreeNAS 11.2

This Installation method will create a Jail that is fully configurable via the FreeNAS GUI

From the FreeNas CLI (shell)

LATEST STABLE (4.1.1.0)

    cd /tmp
    wget https://raw.githubusercontent.com/ma-karai/iocage-plugin-emby/master/emby-server.json
    iocage fetch -P dhcp=on vnet=on bpf=yes allow_raw_sockets=1 -n emby-server.json --branch 'master' 


