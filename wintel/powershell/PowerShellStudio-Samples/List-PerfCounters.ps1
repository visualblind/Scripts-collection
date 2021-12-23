# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  List-PerfCounters.ps1
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

#USAGE EXAMPLES
#list-perfcounters.ps1 -category "memory"
#list-perfcounters.ps1 -category logicaldisk -computername "FILE01"
#list-perfcounters.ps1 -category logicaldisk -computername "FILE01" | 
# format-table CounterName,CounterHelp -autosize -wrap

Param([string]$category="System",
      [string]$computername=$env:computername
     )
    
$perfcategory = New-Object System.Diagnostics.PerformanceCounterCategory($category,$computername)

if ($perfcategory.categorytype -match "SingleInstance") {
    $counters=$perfcategory.getcounters()
}
else {
#get first instance if none specified
    $instance=$perfcategory.getinstancenames()[0]  
    $counters=$perfcategory.getcounters($instance)
}

write $counters




