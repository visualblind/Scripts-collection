# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Show-FolderSize.ps1
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

param([string]$startfolder=$env:temp)

$colItems = (Get-childitem $startfolder | Where-object {$_.PSIsContainer -eq
$True} | sort-object)
foreach ($i in $colitems)

{
$patho = $i.fullname
$objFSO = New-Object -com Scripting.FileSystemObject
$total = "{0:N2}" -f (($objFSO.GetFolder($patho).Size) / 1MB) + " MB"
$output = $patho + ' ' + $total
write-output $output
}
