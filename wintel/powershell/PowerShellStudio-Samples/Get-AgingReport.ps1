# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: Get-AgingReport.ps1 
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
Function Get-AgingReport {
Param($Dir=$(Throw "You must specify a directory path!"))

#verify $Dir exists
if (Test-Path $Dir) {

    $now=Get-Date
    $files=Get-ChildItem -path $dir -recurse | where {($_.GetType()).name -eq "FileInfo"}
    clear-host
    
    #initialize
    $Total2yr=0
    $Total90=0 
    $Total1yr=0
    $Total30=0
    $Total7=0
    $TotalCurrent=0
    $2yrs=0
    $1yr=0
    $3mo=0
    $1mo=0
    $1wk=0
    $current=0
    $count=0

    foreach ($file in $files) {
        $age=($now.subtract(($file.LastWriteTime))).days
        $count=$count+1
        Write-Progress -Activity "File Aging Report" `
        -status $file.DirectoryName -currentoperation $file.name 
        switch ($age) {
          {$age -ge 730} {$2yrs=$2yrs+1;$Total2yr=$Total2Yr+$file.length;break}
          {$age -ge 365} {$1yr=$1yr+1;$Total1yr=$Total1Yr+$file.length;break}
          {$age -ge 90} {$3Mo=$3Mo+1;$Total90=$Total90+$file.length;break} 
          {$age -ge 30} {$1Mo=$1Mo+1;$Total30=$Total30+$file.length;break}
          {$age -ge 7} {$1wk=$1wk+1;$Total7=$Total7+$file.length;break}
          {$age -lt 7}  {$current=$current+1;$TotalCurrent=$TotalCurrent+$file.Length;break}
         }
    }

    $GrandTotal=$Total2yr+$Total1yr+$Total90+$Total30+$Total7+$TotalCurrent
    
    #format file size totals to MB
    $GrandTotal="{0:N2}" -f ($GrandTotal/1048576)
    $Total2yr="{0:N2}" -f ($Total2yr/1048576)
    $Total90="{0:N2}" -f ($Total90/1048576) 
    $Total1yr="{0:N2}" -f ($Total1yr/1048576)
    $Total30="{0:N2}" -f ($Total30/1048576)
    $Total7="{0:N2}" -f ($Total7/1048576)
    $TotalCurrent="{0:N2}" -f ($TotalCurrent/1048576)
    
    clear-host
    Write-Host "File Aging for" $dir.ToUpper()
    Write-Host "2 years:" $2yrs "files" $Total2yr "MB" -foregroundcolor "Red"
    Write-Host "1 year:" $1yr "files" $Total1yr "MB" -foregroundcolor "Magenta"
    Write-Host "3 months:" $3Mo "files" $Total90 "MB" -foregroundcolor "Yellow"
    Write-Host "1 month:" $1mo "files" $Total30 "MB" -foregroundcolor "Cyan"
    Write-Host "1 week:" $1wk "files" $Total7 "MB" -foregroundcolor "Green"
    Write-Host "Current:" $current "files" $TotalCurrent "MB" 
    Write-Host `n
    Write-Host "Totals:" $count "files" $GrandTotal "MB" 
    Write-Host `n
  }
  else {
  Write-Host "Failed to find" $Dir.ToUpper() -foregroundcolor "Red"
  }
}

$dir=Read-Host "Enter a folder path to check for file aging"
Get-AgingReport $Dir
