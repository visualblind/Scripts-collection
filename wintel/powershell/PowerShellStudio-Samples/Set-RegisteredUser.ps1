# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: Set-RegisteredUser.ps1 
# 
# 	Comments: Demonstration script for writing to the registry in PowerShell
# 
#   Disclaimer: This source code is intended only as a supplement to 
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

$path="HKLM:\Software\Microsoft\Windows NT\CurrentVersion"
$Owner=Read-Host "What is the name of the new owner or leave blank"`
`n"to keep the current owner:"
$Org=Read-Host "What is the name of the new organization " `
`n"or leave blank to keep the current owner:"

#Only set property if something was entered
if ($Owner.length -gt 0) {
	set-ItemProperty -path $path -name "RegisteredOwner" -value $Owner
}

#Only set property if something was entered
if ($Org.length -gt 0) {
	Set-ItemProperty -path $path -name "RegisteredOrganization" -value $Org
}

Write-Host "Run Show-RegisteredUser.ps1 to verify the operation."
