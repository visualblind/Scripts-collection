# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-Uptime.ps1
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

Function Get-Uptime {
    Param([string]$computername=$env:computername)
    
    [int]$secup=(Get-WmiObject -class Win32_PerfFormattedData_PerfOS_System -ComputerName $computername).SystemUptime
    [int]$days=([system.math]::Truncate($secup/86400))
    [int]$Hours=($secup/3600)%24
    [int]$Mins=($secup/60)%60
    [int]$secs=$secup%60

    #create new object to hold values
    $obj = New-Object PSObject
    Add-Member -inputobject $obj -membertype NoteProperty -Name Days -value $days
    Add-Member -inputobject $obj -membertype NoteProperty -Name Hours -value $Hours
    Add-Member -inputobject $obj -membertype NoteProperty -Name Minutes -value $Mins
    Add-Member -inputobject $obj -membertype NoteProperty -Name Seconds -value $secs
    Write-Output $obj

}
