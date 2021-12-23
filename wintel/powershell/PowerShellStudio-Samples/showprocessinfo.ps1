# ************************************************************************** 
# 
#     Copyright (c) SAPIEN Technologies, Inc. All rights reserved 
#  This file is part of the PrimalScript 2011 Code Samples. 
# 
#     File: showprocessinfo.ps1 
# 
#     Comments: 
# Display process information and flag those processes that 
# exceed the specified threshold in RED 
# usage: .\showprocessinfo computername memorythreshold_in_bytes 
# example: .\showprocessinfo . 1024000 
# 
#  Disclaimer: This source code is intended only as a supplement to 
#                 SAPIEN Development Tools and/or on-line documentation.  
#                 See these other materials for detailed information 
#                 regarding SAPIEN code samples. 
# 
#     THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY 
#     KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
#     IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A 
#     PARTICULAR PURPOSE. 
# 
# ************************************************************************** 

Param([string] $Computername=$env:computername,[int] $MemoryThreshhold=10MB) 

$colItems = get-wmiobject -class "Win32_Process" -namespace "root\CIMV2" -computername $Computername 

foreach ($objItem in $colItems) { 
    if ($objItem.WorkingSetSize -gt $MemoryThreshhold) { 
        write-host $objItem.Name $objItem.WorkingSetSize -foregroundcolor "red" 
    } 
    else { 
        Write-Host $objItem.Name $objItem.WorkingSetSize
    } 
} 
