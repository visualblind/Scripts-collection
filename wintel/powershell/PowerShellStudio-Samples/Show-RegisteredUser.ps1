# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: Show-RegisteredUser.ps1
# 
# 	Comments:
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
$reg=Get-ItemProperty $path

#$reg	#Uncomment this line if you want to see all of the available properties

write-Host "Registered Owner:"$reg.RegisteredOwner
write-Host "Registered Organization:"$reg.RegisteredOrganization
Write-Host `n	#write a blank line just to make it easier to read