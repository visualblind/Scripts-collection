# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Convert-HistoryToScript.ps1
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

$file=Read-Host "Enter the filename and path for the script file"

#delete the script if it already exists
if ($file) {
Remove-Item $file
}

#add a brief header
write ("# " + ($file.substring($file.lastindexof("\")+1)).ToUpper()) | Out-File $file
write "# Generated from PowerShell History" | Out-File $file -append
write ("# " + (Get-Date)) | Out-File $file -append
write "#Author: $env:username" | Out-File $file -append
for ($i=0;$i -le 80;$i++) {$divider=$divider + "#";$i++}
write $divider | Out-File $file -append

$history=Get-History -count $maximumhistorycount | select commandline
for ($i=0;$i -le $history.count;$i++) {
$history[$i].commandline | Out-File $file -append
}
