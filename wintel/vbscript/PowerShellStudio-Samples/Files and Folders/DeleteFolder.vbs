'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  DeleteFolder.vbs
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

'Delete folder
'ANY FILES OR SUBDIRECTORIES WILL ALSO BE DELETED
On Error Resume Next
dim objFSO

'folder to delete
strFldr="C:\NewFolder"

set objFSO=CreateObject("Scripting.FileSystemObject")
rc=MsgBox("Are you sure you want to delete " & strFldr,vbYesNo+vbQuestion+vbDefaultButton2,"Warning")
If rc=vbYes Then objFSO.DeleteFolder(strFldr)

set objFSO=Nothing