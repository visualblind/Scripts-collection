'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetCharSet.vbs
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

Dim IE
Const Font = "Wingdings 2"
call CreateIE()
For I = 33 to 254

ie.Document.Write "<FONT FACE=" & chr(34) & "Verdana" & chr(34) &_
		  ">" & I & " - " & chr(I) & " - " & "</Font>"
ie.Document.Write "<FONT FACE=" & chr(34) & Font & chr(34) &_
		  ">" & chr(I) & "</Font><BR>"

Next

Sub CreateIE()
	On Error Resume Next
	Set IE = CreateObject("InternetExplorer.Application")
	ie.height=370
	ie.width=500
	ie.menubar=0
	ie.toolbar=0
	ie.navigate "About:Blank"
	ie.visible=1
	Do while ie.Busy
		' wait for page to load
	Loop
	ie.Document.Write "<html><Body><br>"
End Sub
