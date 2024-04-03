'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CheckIfFileExists.vbs
'
'	Comments:
'
'   Disclaimer: This source code is intended only as a supplement to 
'				SAPIEN Development Tools and/or on-line documentation.  
'				See these other materials for detailed information 
'				regarding SAPIEN code samples.
'
'	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
'	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
'	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
'	PARTICULAR PURPOSE.
'
'**************************************************************************

'Check if file exists
On Error Resume Next

dim objFSO

strFile="c:\MyLogfile.txt"
set objFSO=CreateObject("Scripting.FileSystemObject")
if objFSO.FileExists(strFile) then
	wscript.Echo strFile  & " exists"
	'insert any other code you want to execute if file exists
else
	wscript.Echo "Cannot find " & strFile
	'insert any other code or error handling you want to execute
	'if file does not exist
end if
