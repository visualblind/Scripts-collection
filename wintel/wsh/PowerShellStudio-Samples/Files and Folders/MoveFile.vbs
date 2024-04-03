'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  MoveFile.vbs
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
'Move File

On Error Resume Next
dim objFSO
dim objFile

'specify filename and path for file to move
strFile="c:\MyLogfile.txt"
'specify target destination
strDest="c:\NewFolder\"

set objFSO=CreateObject("Scripting.FileSystemObject")
'move will fail if file already exists in target destination
objFSO.MoveFile strFile,strDest
if err.number=0 then
	wscript.Echo "Successfully moved " & strFile & " to " & strDest
else
	wscript.Echo "Failed to move " & strFile & " to " & strDest
end if
