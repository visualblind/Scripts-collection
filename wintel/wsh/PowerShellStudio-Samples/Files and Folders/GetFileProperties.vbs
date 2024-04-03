'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetFileProperties.vbs
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

'Get File Properties
On Error Resume Next

dim objFSO
dim objFile

strFile="c:\MyLogFile.txt"
set objFSO=CreateObject("Scripting.FileSystemObject")
set objFile=objFSO.GetFile(strFile)

wscript.Echo "File Name:" & vbtab & objFile.Name
wscript.Echo "Short File Name:" & vbtab & objFile.ShortName
wscript.Echo "File Path:" & vbtab & objFile.Path
wscript.Echo "Date Created:" & vbtab & objFile.DateCreated
wscript.Echo "Date Last Accessed:" & vbtab & objFile.DateLastAccessed
wscript.Echo "Date Last Modified:" & vbtab & objFile.DateLastModified
wscript.Echo "File Size:" & vbtab & objFile.Size
wscript.Echo "File Attributes:"
if objFile.Attributes AND 0 then wscript.Echo " Normal"
if objFile.Attributes AND 1 then wscript.Echo " Read-only"
if objFile.Attributes AND 2 then wscript.Echo " Hidden"
if objFile.Attributes AND 4 then wscript.Echo " System"
if objFile.Attributes AND 8 then wscript.Echo " Volume"
if objFile.Attributes AND 16 then wscript.Echo " Directory"
if objFile.Attributes AND 32 then wscript.Echo " Archive Bit is set"
if objFile.Attributes AND 1024 then wscript.Echo " Alias"
if objFile.Attributes AND 2048 then wscript.Echo " Compressed"


