# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: get-disksize.ps1 
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

Param ($Computer = "localhost")
$colDisks = get-wmiobject Win32_LogicalDisk -computer $computer 
" Device ID    Type               Size(mb)     Free Space(mb)"
ForEach ($Disk in $colDisks)
{
 $drivetype=$disk.drivetype
 Switch ($drivetype)
 {
     2 {$drivetype="FDD"}
     3 {$drivetype="HDD"}
     5 {$drivetype="CD "}
 }

"    {0}         {1}       {2,15:n}  {3,15:n}" -f $Disk.DeviceID, $drivetype, $($disk.Size/1mb), $($disk.freespace/1mb)
}
""