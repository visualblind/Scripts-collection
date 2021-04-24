Get-NetIPConfiguration | ? {$_.InterfaceAlias -eq 'Ethernet'} | Get-NetConnectionProfile | Set-DnsClient -RegisterThisConnectionsAddress:$False
# netsh interface ipv4 show dnsservers