'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetFolderProperties.vbs
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

'Get Folder Properties

On Error Resume Next

dim objFSO
dim objFldr
'Specify folder you want information about
strFldr="c:\NewFolder"
set objFSO=CreateObject("Scripting.FileSystemObject")
'get a reference to the folder
set objFldr=objFSO.GetFolder(strFldr)

'list out properties
wscript.Echo "Folder Name:" & vbtab & objFldr.Name
wscript.Echo "Short Folder Name:" & vbtab & objFldr.ShortName
wscript.Echo "Folder Path:" & vbtab & objFldr.Path
wscript.Echo "Date Created:" & vbtab & objFldr.DateCreated
wscript.Echo "Date Last Accessed:" & vbtab & objFldr.DateLastAccessed
wscript.Echo "Date Last Modified:" & vbtab & objFldr.DateLastModified
wscript.Echo "Folder Size (bytes):" & vbtab & objFldr.Size
wscript.Echo "Folder Attributes:"
if objFldr.Attributes AND 0 then wscript.Echo " Normal"
if objFldr.Attributes AND 1 then wscript.Echo " Read-only"
if objFldr.Attributes AND 2 then wscript.Echo " Hidden"
if objFldr.Attributes AND 4 then wscript.Echo " System"
if objFldr.Attributes AND 8 then wscript.Echo " Volume"
if objFldr.Attributes AND 16 then wscript.Echo " Directory"
if objFldr.Attributes AND 32 then wscript.Echo " Archive Bit is set"
if objFldr.Attributes AND 1024 then wscript.Echo " Alias"
if objFldr.Attributes AND 2048 then wscript.Echo " Compressed"

