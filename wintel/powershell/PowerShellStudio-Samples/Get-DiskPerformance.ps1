# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  GetDiskPerformance.ps1
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

$category="LogicalDisk"
$perfcategory = New-Object System.Diagnostics.PerformanceCounterCategory($category)
$instance="C:"
$counters=$perfcategory.getcounters($instance)
write ("{0} performance counters for {1}" -f $category,$instance)
foreach ($counter in $counters) {
    $value=(New-Object System.Diagnostics.PerformanceCounter "LogicalDisk",$counter.countername,$instance).NextValue()
    write ("{0} = {1}" -f $counter.countername,$value)
    }


