'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  WriteToExistingFile.vbs
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
'Write to existing text file
On Error Resume Next
dim objFSO
dim objFile

Const ForWriting=2
'specify filename and path for file to open
strFile="c:\MyLogfile.txt"

set objFSO=CreateObject("Scripting.FileSystemObject")
'if file already exists, value of TRUE forces overwriting file
set objFile=objFSO.OpenTextFile(strFile,ForWriting)

objFile.WriteLine Now & " this is a new line"

objFile.Close

