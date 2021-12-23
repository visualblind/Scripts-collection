# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Get-PerfCounterData.ps1
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


Param ([string]$category="System",
       [string]$instance,
       [string]$computername=$env:computername
       )
       
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
        $counter.countername,$instance,$computername).NextValue()
        #create a property for each counter and add it to the object
        $obj | Add-Member NoteProperty -name $counter.countername -value $value
        }
    
    #write the performance data object to the pipeline
    write $obj

}

Trap { 
    #continue and ignore errors 
    Continue 
}

$perfcategory = New-Object System.Diagnostics.PerformanceCounterCategory($category,$computername)

#if category doesn't have a category type it likely doesn't exist, display a warning and exit.
if (! $perfcategory.categoryType) {
    Write-Warning ("{0} is not a valid performance counter category on {1}" -f $category.ToUpper(),$computername.ToUpper())
    $categories=[system.diagnostics.performancecountercategory]::GetCategories($computername) | 
     sort CategoryName | select CategoryName
    [string]$categorystring=""
    $categories | foreach {$categorystring+=$_.categoryname + ", "}
    #remove trailing comma
    $categorystring=$categorystring.Remove($categorystring.LastIndexOf(","))
    Write-Warning ("Valid categories are {0}" -f $categorystring )
    Return
}

#if single instance, get peformance counters
if ($perfcategory.categorytype -match "SingleInstance") {
    $counters=$perfcategory.getcounters()

}
else {
    
    #get first instance if none specified so we can get the counters
    if (! $instance) {
        $instances=$perfcategory.getinstancenames()
        $counters=$perfcategory.getcounters($instance[0])
    }
    else {
    #otherwise get counters using specified instance
        $counters=$perfcategory.getcounters($instance)
    }

}

#enumerate performance data for all instances of the given category
if ($instance) {

    New-PerfDataObject -computername $computername -category $category `
    -instance $instance -counters $counters
    
}
else {

    foreach ($instance in $instances) {
    #create a performance data object for each instance
    
     New-PerfDataObject -computername $computername -category $category `
    -instance $instance -counters $counters
    
    }
    
}

