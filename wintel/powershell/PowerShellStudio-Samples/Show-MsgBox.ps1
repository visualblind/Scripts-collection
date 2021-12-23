# **************************************************************************
# 
# 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
#    This file is part of the PrimalScript 2011 Code Samples.
# 
# 	File:  Show-MsgBox.ps1
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

Function Show-Msgbox {
  Param([string]$message=$(Throw "You must specify a message"),
      [string]$button="okonly",
      [string]$icon="information",
      [string]$title="Message Box"
     )
     
# Buttons: OkOnly, OkCancel, AbortRetryIgnore, YesNoCancel, YesNo, RetryCancel
# Icons: Critical, Question, Exclamation, Information

  [reflection.assembly]::loadwithpartialname("microsoft.visualbasic") | Out-Null

  [microsoft.visualbasic.interaction]::Msgbox($message,"$button,$icon",$title) 

 }

$rc=Show-Msgbox -message "Do you know what you're doing?" `
-icon "exclamation" -button "YesNoCancel" -title "Hey $env:username!!"

Switch ($rc) {
 "Yes" {"I hope your resume is up to date."}
 "No" {"Wise move."}
 "cancel" {"When in doubt, punt."}
}

