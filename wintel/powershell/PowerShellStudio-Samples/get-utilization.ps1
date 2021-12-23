# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-Utilization.ps1
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

Function Get-Utilization {
    Param([string]$computername=$env:computername,
          [string]$ID="C:"
          )
          
     #suppress errors messages    
    $errorActionPreference="silentlycontinue"      
          
    $drive=Get-WmiObject Win32_Logicaldisk -filter "DeviceID='$ID'" `
    -computername $computername -errorAction "silentlycontinue"
    
    if ($drive.size) {
    
        #divide size and freespace by 1MB because they are UInt64
        #and I can't do anything with them in there native type
        
        $size=$drive.size/1MB
        $free=$drive.freespace/1MB
          
        $utilization=($size-$free)/$size
        
        write $utilization
    }
    else {
    #there as an error so return a value that can't be mistaken
    #for drive utilization
        write -1
    }

}

#Sample usage
$computer=$env:computername
$drive="C:"
$u=Get-Utilization $computer $drive

#format $u as a percentage to 2 decimal points

$percent="{0:P2}" -f $u

if ($u -eq -1) {
    $msg="WARNING: Failed to get drive {0} on {1}" -f $drive,$computer
    $color="RED"
}
elseif ($u -ge .75) {
    $msg="WARNING: Drive {0} on {1} is at {2} utilization." -f $drive,$computer,$percent
    $color="RED"
}
else {
    $msg="WARNING: Drive {0} on {1} is at {2} utilization." -f $drive,$computer,$percent
    $color="GREEN"
}

Write-Host $msg -foregroundcolor $color
