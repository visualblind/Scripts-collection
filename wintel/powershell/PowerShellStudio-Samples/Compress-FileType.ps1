# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Compress-FileType.ps1
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

# ==============================================================================================
# 
# Microsoft PowerShell Source File -- Created with SAPIEN Technologies PrimalScript 2011
# 
# NAME: Compress-FileType.ps1
# 
# AUTHOR: Jeffery Hicks , SAPIEN Technologies, Inc.
# DATE  : 1/13/2009
# 
# COMMENT: Specify a comma separated list of file types and a drive. The script will use
# WMI to find the files and compress them if they aren't already compressed. 
# 
# USAGE: Compress-FileType -extensions "txt,doc,log" | out-file results.txt
# ==============================================================================================

Param (
[string]$extensions="txt,bmp,doc,xls,docx,xlsx,ps1,vbs,wsf",
[string]$drive="c:",
[string]$computer=$env:computername,
[switch]$debug
)

if ($debug) {
    $debugPreference="Continue"
}

Write-Debug "Connecting to drive $drive on $computer"

Write-Progress -Activity "Compress File Types" -status "Getting current freespace for $drive on $computer"

#get freespace before
$disk=Get-WmiObject win32_logicaldisk -filter "deviceid='$drive'" -computername $computer
$freeBefore=$disk.freespace

Write-Debug "Freespace before is $freeBefore"

#build query
$extFilter="{0}{1}{2}" -f "(Extension='",($extensions.replace(",","' OR Extension='")),"')"

$query="Select CSName,Name,Compressed,Extension,FileSize from CIM_DATAFILE Where Drive='$Drive' AND Compressed='FALSE' AND $extFilter"

Write-Debug "Query = $query"

Write-Progress -Activity "Compress File Types" `
-status "Running query $query on $computer" `
-currentoperation "Please wait...this may take several minutes..."

Write-Debug "Getting files"
$files=Get-WmiObject -query $query -computername $computer

$filecount=$files.count
Write-Debug "Found $filecount files"

#only process if files were returned
if ($filecount -gt 0) {
    #keep a running count of compressed files
    $iCompressed=0
    $iFailures=0
    $i=0
    Write-Debug "processing files"
    
    foreach ($file in $files) {
     $i++
     [int]$percent=($i/$filecount)*100
     Write-Debug $file.name
     Write-Progress -Activity "Compress File Types" -Status "Compressing" -currentoperation $file.name -percentComplete $percent
        $rc=$file.Compress()
            Switch ($rc.returnvalue) {
                 0 { $Result="The request was successful"
                     #increment the counter
                     $iCompressed++
                     #write the WMI file object to the pipeline
                     #for later processing
                     write $file | select CSName,Name,FileSize,Extension,Compressed         
                     Break}
                     
                 2 { $Result="Access was denied." ; Break}
                 8 { $Result="An unspecified failure occurred."; Break}
                 9 { $Result="The name specified was invalid."; Break}
                 10 { $Result="The object specified already exists."; Break} 
                 11 { $Result="The file system is not NTFS."; Break}
                 12 { $Result="The operating system is not supported."; Break}
                 13 { $Result="The drive is not the same."; Break}
                 14 { $Result="The directory is not empty."; Break}
                 15 { $Result="There has been a sharing violation." ; Break}
                 16 { $Result="The start file specified was invalid."; Break}
                 17 { $Result="A privilege required for the operation is not held."; Break}
                 21 { $Result="A parameter specified is invalid."; Break}
            } #end Switch
            
            #display a warning message if there was a problem
            if ($rc.returnvalue -ne 0) {
              $msg="Error compressing: {0}. {1}" -f $file.name,$Result
              Write-Warning $msg
              $iFailures++
            }
            Write-Debug "Result=$result"
    }
    
    Write-Progress -Activity "Compress File Types" -status "Getting current freespace for $drive on $computer"
    
    #get freespace after
    $disk=Get-WmiObject win32_logicaldisk -filter "deviceid='$drive'" -computername $computer
    $freeAfter = $disk.freespace
    
    $freeDiff = $freeAfter - $freeBefore
    
    Write-Debug "Freespace after is $freeBefore"
    Write-Debug "Freespace difference is $freeDiff"
    Write-Debug "Presenting summary"
    
    Write-Progress -Activity "Compress File Types" -status "Finished" -completed $True
    
    Write-Host "Summary" -ForegroundColor CYAN
    Write-Host "**********************************" -ForegroundColor CYAN
    Write-Host "Computer         : $computer" -foregroundcolor CYAN
    Write-Host "File types       : $extensions" -foregroundcolor CYAN
    Write-Host "Drive            : $drive" -foregroundcolor CYAN
    Write-Host "Total Files      : $filecount" -foregroundcolor CYAN
    Write-Host "Compressed       : $iCompressed" -foregroundcolor CYAN
    Write-Host "Failures         : $iFailures" -foregroundcolor CYAN
    Write-Host "Free bytes before: $freeBefore" -foregroundcolor CYAN
    Write-Host "Free bytes after : $freeAfter" -foregroundcolor CYAN
    Write-Host "Bytes Recovered  : $freeDiff"  -foregroundcolor CYAN
}
else {
    Write-Warning "No matching files ($extensions) found on drive $drive on $computer"

}

#end of script
