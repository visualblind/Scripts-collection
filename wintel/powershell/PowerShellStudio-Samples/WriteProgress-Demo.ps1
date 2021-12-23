# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  WriteProgress-Demo.ps1
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

[string]$dir="$env:userprofile\documents\"

$act="File report for "+$dir.ToUpper()

Write-Progress -Activity $act -Status "Connecting" -CurrentOperation "Please wait"

Get-ChildItem -path $dir -recurse | 
where {$_.length -gt 5mb} -outvariable data |
foreach -begin {
  clear-host
  $i=0
  } `
    -process {
     $i=$i+1
     Write-Progress -activity "Searching for files in $dir" `
     -currentoperation "Scanning $_.directory" `
     -status "Progress:" -percentcomplete ($i/100)}`
  -end {
    Write-Host "finished" -foregroundcolor CYAN
    Write-Host "counted $i files" -foregroundcolor CYAN
   }
   
$data | sort Length -desc | select Fullname,Length

