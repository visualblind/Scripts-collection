' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: FunGetCurDir.vbs 
' 
' 	Comments: This function will return the current directory path
' for the script.  
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next

'this is sample code on how to use the function

WScript.Echo "The current directory for " & wscript.scriptname &_
" is " & GetCurDir(WScript.ScriptFullName,WScript.ScriptName)

wscript.quit

'///////////////////////////////////////////////////////
Function GetCurDir(strScriptFullName,strScriptName)
On Error Resume Next

iName=InStr(strScriptFullName,strScriptName)
GetCurDir=Left(wscript.ScriptFullName,iName-1)

end Function

'EOF