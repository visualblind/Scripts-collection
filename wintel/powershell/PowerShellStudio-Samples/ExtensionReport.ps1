# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#   This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File: ExtensionReport.ps1 
# 
# 	Comments:
# This script will prompt you for a directory name and then display a list of
# all file extensions sorted and grouped. As written the script will
# recurse through all subfolders.
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
# 

[string]$dir=Read-Host "What directory do you want to start in?"
Write-Host "File report for "$dir.ToUpper()
get-childitem -path $dir -recurse|where {$_.Gettype().name -eq "FileInfo"} |group-object extension -noelement|sort count -desc
