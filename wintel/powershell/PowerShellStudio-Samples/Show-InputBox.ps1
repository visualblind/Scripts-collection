# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Show-InputBox.ps1
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

Function Show-Inputbox {
 Param([string]$message=$(Throw "You must enter a prompt message"),
       [string]$title="Input",
       [string]$default
       )
       
 [reflection.assembly]::loadwithpartialname("microsoft.visualbasic") | Out-Null
 [microsoft.visualbasic.interaction]::InputBox($message,$title,$default)


}

$c=Show-Inputbox -message "Enter a computername" `
-title "Computername" -default $env:Computername

if ($c.Trim()) {
  Get-WmiObject win32_computersystem -computer $c
  }
