# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: Convert-WMITime.ps1
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
Function Convert-WMITime{
param([string]$WMITime)

$yr=[string]$WMITime.Substring(0,4)
$mo=[string]$WMITime.substring(4,2)
$dy=[string]$WMITime.substring(6,2)
$tm=[string]$WMITime.substring(8,6)
$hr=[string]$tm.Substring(0,2)
$min=[string]$tm.substring(2,2)
$sec=[string]$tm.substring(4,2)
#create string
$s="$mo/$dy/$yr "+$hr+":"+$min+":"+$sec
#cast result as DateTime type
$result=[DateTime]$s
return $result
}

$t="20070214115312.491614-300"
Convert-wmitime $t

