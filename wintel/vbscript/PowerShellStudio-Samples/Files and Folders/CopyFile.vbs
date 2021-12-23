'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CopyFile.vbs
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

'Copy File
On Error Resume Next
dim objFSO
dim objFile

'specify filename and path for file to copy
strFile="c:\MyLogfile.txt"
'specify target destination
strDest="c:\NewFolder\"

set objFSO=CreateObject("Scripting.FileSystemObject")

'set last parameter to TRUE if you want to overwrite
'an existing file with the same name
objFSO.CopyFile strFile,strDest,TRUE
if err.number=0 then
	wscript.Echo "Successfully copied " & strFile & " to " & strDest
else
	wscript.Echo "Failed to copy " & strFile & " to " & strDest
end if

