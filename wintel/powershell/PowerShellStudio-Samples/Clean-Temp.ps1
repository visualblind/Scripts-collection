# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Clean-Temp.ps1
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

#Clean-Temp.ps1
#Delete all files in %TEMP% that are older than the last time the computer
#was started

#  ****************************************************************
#  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
#  * THOROUGHLY IN A LAB SETTING. USE AT YOUR OWN RISK.           * 						  * 
#  ****************************************************************

Function Remove-File {
#-Recurse will search through all subfolders
#-hidden will the -force parameter for Get-ChildItem
#-force will use the -force parameter with Remove-Item

    Param([string]$path=$env:temp,
          [datetime]$cutoff=$(Throw "You must enter a cutoff date!"),
          [Switch]$Recurse,
          [Switch]$hidden,
          [Switch]$force)
    
    Write-Host "Removing files in $path older than $cutoff" -foregroundcolor CYAN
        
    $cmd="Get-ChildItem $path"
    
    if ($recurse) {
        $cmd=$cmd + " -recurse"
    }
    
    if ($hidden) {
        $cmd=$cmd + " -force"
    }
    
    #create an array to store file information
    $files=@()
    
    # execute the command string filtering out directories
    &$executioncontext.InvokeCommand.NewScriptBlock($cmd) | 
    where {-not $_.PSIsContainer -and $_.lastwritetime -lt $cutoff} | 
     foreach {
        #add current file to array
        $files+=$_
        
        if ($force) {
        #YOU MUST REMOVE -WHATIF TO ACTUALLY DELETE FILES
            Remove-Item $_.fullname -force 
            #-WHATIF
            }
        else {
            Remove-Item $_.fullname 
            #-WHATIF
            }     
    } #end forEach
    
    $stats=$files | Measure-Object -Sum length
    $msg="Attempted to delete {0} files for a total of {1} MB ({2} bytes)" -f 
    $stats.count,($stats.sum/1MB -as [int]),$stats.sum
    
    Write-Host $msg -foregroundcolor CYAN

}

$query="Select LastBootUpTime from Win32_OperatingSystem"
$boot=Get-WmiObject -query $query
[datetime]$boottime=$boot.ConvertToDateTime($boot.Lastbootuptime)

#YOU MUST UNCOMMENT THESE LINES IN ORDER TO DELETE FILES
#USE WITH CAUTION
# Remove-File $env:temp $boottime -recurse -hidden -force
# 
# Remove-File "c:\windows\temp" $boottime -recurse -hidden -force


