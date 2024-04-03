'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  CreateTextFile.vbs
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

'create a text file example
On Error Resume Next
dim objFSO
dim objFile

'specify filename and path for file to create
strFile="c:\MyLogfile.txt"

set objFSO=CreateObject("Scripting.FileSystemObject")
'if file already exists, value of TRUE forces overwriting file
set objFile=objFSO.CreateTextFile(strFile,TRUE)

objFile.WriteLine "This is an entry into my logfile"
'write 3 blank lines
objFile.WriteBlankLines(3)
objFile.WriteLine "Here is the last line of my logfile"

wscript.Echo "See " & strFile & " for results"
'close file
objFile.Close

set objFSO=Nothing
set objFile=Nothing
