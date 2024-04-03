' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: chkengine.vbs 
' 
' 	Comments:
'	determine which engine was invoked, ie CSCRIPT or WSCRIPT
'	Function returns either cscript.exe or wscript.exe
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

ON ERROR RESUME NEXT
WScript.Echo WScript.ScriptName
wscript.echo "You invoked " & ChkEngine & " to run this script."

'\\\\\\\\\\\\\\\\\\\\\\
'ChkEngine Function
'\\\\\\\\\\\\\\\\\\\\\\
Function ChkEngine()

ON ERROR RESUME NEXT

strEngine=Wscript.FullName

'there should never really be an error but just in case:
if Err.Number <>0 then
  wscript.echo "Error!"
  wscript.echo "Error (" & Hex(Err.Number) & ") Description: " & Err.Description
  wscript.quit
end if

PosX=InStrRev(strEngine,"\",-1,vbTextCompare)
ChkEngine=LCase(Mid(strEngine,PosX+1))

End Function

