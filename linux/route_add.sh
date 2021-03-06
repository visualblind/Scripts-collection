ES
       route add -net 127.0.0.0 netmask 255.0.0.0 dev lo
              adds the normal loopback entry, using netmask 255.0.0.0 and associated with the "lo" device (assuming this device  was  previously  set  up
              correctly with ifconfig(8)).

       route add -net 192.56.76.0 netmask 255.255.255.0 dev eth0
              adds a route to the local network 192.56.76.x via "eth0".  The word "dev" can be omitted here.

       route del default
              deletes the current default route, which is labeled "default" or 0.0.0.0 in the destination field of the current routing table.

       route add default gw mango-gw
              adds  a  default  route (which will be used if no other route matches).  All packets using this route will be gatewayed through "mango-gw".
              The device which will actually be used for that route depends on how we can reach "mango-gw" - the static route to "mango-gw" will have  to
              be set up before.

       route add ipx4 sl0
              Adds the route to the "ipx4" host via the SLIP interface (assuming that "ipx4" is the SLIP host).

       route add -net 192.57.66.0 netmask 255.255.255.0 gw ipx4
              This command adds the net "192.57.66.x" to be gatewayed through the former route to the SLIP interface.

       route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0
              This is an obscure one documented so people know how to do it. This sets all of the class D (multicast) IP routes to go via "eth0". This is
              the correct normal configuration line with a multicasting kernel.

route add default gw 10.10.10.1 wlan0




#iface eth0 inet manual
allow-hotplug eth0  
iface eth0 inet static  
    address 10.10.10.15
    netmask 255.255.255.0
    network 10.10.10.0
    broadcast 10.10.10.255