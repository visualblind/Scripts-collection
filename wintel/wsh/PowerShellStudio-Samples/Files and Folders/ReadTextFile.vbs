'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ReadTextFile.vbs
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
'Read Text File
On Error Resume Next
dim objFSO
dim objFile

Const ForReading=1

strFile="C:\MyLogFile.txt"

set objFSO=CreateObject("Scripting.FileSystemObject")
set objFile=objFSO.OpenTextFile(strFile,ForReading)

'read in each line of data until you reach the end of the file
do While objFile.AtEndOfStream<>True
strEntry=objFile.ReadLine

'you can now do what ever you want with the line 
'as referenced with the strEntry variable such as
'echoing it back (e.g. wscript.Echo strEntry) or passing it
'as a variable to a function of subroutine (e.g. MyFunction strEntry)

wscript.Echo strFile
loop	

'close file
objFile.Close

