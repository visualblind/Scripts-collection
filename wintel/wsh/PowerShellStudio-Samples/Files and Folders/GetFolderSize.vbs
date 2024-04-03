' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetFolderSize.vbs 
' 
' 	Comments: Using an Internet Explorer window, display sub folder sizes
'	for a starting root folder.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

On Error Resume Next

Dim objFSO,objFldr,objSubs,oIE

strPath=InputBox("Enter in a directory path.  Only the top level folder sizes will be calculated.","Directory Size Report","c:\")
If strPath="" Then WScript.Quit 'quit if cancelled or nothing entered.

'add trailing \
If Right(strPath,1)<>"\" Then
	strPath=strPath & "\"
End If

Set oIE = CreateObject("InternetExplorer.Application")
oIE.navigate "about:blank"
oIE.ToolBar = False
oIE.AddressBar = False
oIE.Top = 10
oIE.Left = 10
oIE.Width = 700
oIE.Height = 600
oIE.Visible = True
oIE.menubar = False
oIE.StatusBar = True
oIE.Document.writeln "<font face=Verdana size=3>Folder Size for " & strPath & "<P><HR>"
oIE.StatusText="Examining " & strPath

Set objFSO=CreateObject("Scripting.FileSystemObject")
set objFldr=objFSO.GetFolder(strPath)
If Err.number<>0 Then 
	oIE.Document.writeln "<font face=Verdana size=2 color=RED>Failed to find " & strPath & "</font>"
	WScript.Quit
End If

Set objSubs=objFldr.SubFolders

oIE.Document.writeln "<Table border=0 width=100%>"
For Each fldr In objSubs
oIE.StatusText="Examining " & fldr.Name
	strSize=FormatNumber(Fldr.Size/1048576,2)
	oIE.Document.writeln "<TR><TD><font face=Verdana size=2>" & fldr.name &_
	 "</font></TD><TD><font face=Verdana size=2> " & strSize &_
	 " MB</font></TD><TD><span style=background-color=RED;width:" & strSize/10 & "></span></TD></TR>"
Next
oIE.Document.writeln "</Table>"
oIE.Document.writeln "<br><font face=Verdana size=1 <i>Scale is one hash for every 10MB<br></font></i>"
oIE.StatusBar=False
Set oIE=Nothing
WScript.Quit
