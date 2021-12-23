# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  ProcPerf.ps1
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

#Display process performance information for a given computer

Function Get-ProcPerf {
    Param([string]$computername=$env:computername)
    
    Function New-PerfDataObject {
    Param([string]$computername,
          [string]$category,
          [string]$instance,
          [array]$counters
          )

    #create empty object
    $obj = New-Object PSobject
    $obj | Add-Member NoteProperty -name "Computername" -value $computername.ToUpper()
    $obj | Add-Member NoteProperty -name "Category" -value $category.toUpper()
    $obj | Add-Member NoteProperty -name "Instance" -value $instance
    
    #get counters and data
    foreach ($counter in $counters) {
        $value=(New-Object System.Diagnostics.PerformanceCounter $category,`
        $counter,$instance,$computername).NextValue()
        #create a property for each counter and add it to the object
        $obj | Add-Member NoteProperty -name $counter -value $value
        }
    
    #write the performance data object to the pipeline
    write $obj

}
    
    $category="Process"
    $counters="ID Process","Working Set","Page File Bytes","Virtual Bytes","Thread Count"
    
    $perfcategory = New-Object System.Diagnostics.PerformanceCounterCategory($category,$computername)
    $instances=$perfcategory.getinstancenames()
    
    foreach ($instance in $instances) {
       New-PerfDataObject -computername $computername -category $category -instance $instance -counters $counters |
       where {$_."ID Process" -ne 0} | select Instance,"ID Process","Thread Count",`
       @{name="WorkingSet (MB)";expression={"{0:N2}" -f ($_."working set"/1MB)}},`
       @{name="Virtual Memory (MB)";Expression={"{0:N2}" -f ($_."Virtual Bytes"/1MB) }},`
       @{name="PageFile Memory (MB)";Expression={"{0:N2}" -f ($_."Page File Bytes"/1MB) }}
    } #end foreach
}

Get-ProcPerf | sort "WorkingSet (MB)" -desc | select -first 10

