:: Output only network adapter name and IP addresses
ipconfig /all | findstr /IR "ipv4 ethernet adapter" | findstr /IRV "description tunnel vpn dial bluetooth [2-9]:$" | findstr /LV "*"

:: Using grep from gnuwin32 output only network adapter name and IP addresses
ipconfig /all | grep -iE "ipv4|ethernet|adapter" | grep -iEv "description|tunnel|vpn|dial|bluetooth|[2-9]:$" | grep -iFv "connection*"

:: Yields the bare essentials (hostname, adapter name, MAC, IPv4, subnet, gateway, DNS)
ipconfig /all | findstr -iv "ipv6 bluetooth Description DHCP Autoconfiguration Netbios routing wins node Connection-specific obtained expires disconnected"

:: Configure Environmental Variable
SET "ip=ipconfig /all | findstr /IR "ipv4 ethernet adapter" | findstr /IRV "description tunnel vpn dial bluetooth [2-9]:$" | findstr /LV "*""
SET "ipgrep=ipconfig /all | grep -iE "ipv4|ethernet|adapter" | grep -iEv "description tunnel vpn dial bluetooth [2-9]:$" | grep -iFv "connection*""
SET "ipa=ipconfig /all | findstr -iv "ipv6 bluetooth Description DHCP Autoconfiguration Netbios routing wins node Connection-specific obtained expires disconnected""
