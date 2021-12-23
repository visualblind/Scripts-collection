# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: ShowServices.ps1 
# 
# 	Comments:
# 	stopped services will display in RED
# 	running services will display in GREEN
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

$strComputer="."
$colItems=get-wmiobject -class "Win32_Service" -namespace "root\CIMV2" `
-computername $strComputer | sort "Caption" 

foreach ($objItem in $colItems) {
	if ($objItem.State -eq "Running") {
	write-host $objItem.Caption "("$objItem.Name")"  -foregroundcolor "green" }
	else {write-host $objItem.Caption "("$objItem.Name")" -foregroundcolor "red" }
}
