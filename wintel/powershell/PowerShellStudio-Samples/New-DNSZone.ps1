# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  New-DNSZone.ps1
# 
# 	Comments:
# 
#    Disclaimer: This source code is intended only as a supplement to 
# 				SAPIEN Development Tools and/or on-line documentation.  
# 				See these other materials for detailed information 
# 				regarding SAPIEN code samples.
# 
# 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
# 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
# 	PARTICULAR PURPOSE.
# 
# **************************************************************************

Function New-DNSZone {
#Valid zone choices are:
# 0 Primary zone.
# 1 Secondary zone.
# 2 Stub zone.
# 3 Zone forwarder.


    Param([string]$computername=$(Throw "You must specify a DNS Server name"),
          [string]$zonename=$(Throw "You must specify the zone name"),
          [string]$zonetype=0,
          [switch]$dsintegrated,
          [string]$datafile,
          [string]$ip
        )
    
   [wmiclass]$dns="\\$computername\root\microsoftdns:MicrosoftDNS_Zone"
   $msg="Creating zone {0} on {1} of type {2}. DSIntegration is {3}" -f $zonename,$computername,$zonetype,$dsintegrated
   Write-Host $msg
   $zone=$dns.CreateZone($zonename,$zonetype,$dsintegrated,$datafile,$ip)
   write $zone.RR

}
#example
# New-DNSZone -computername "Pluto" -zonename "research.mycompany.local" -dsintegrated
