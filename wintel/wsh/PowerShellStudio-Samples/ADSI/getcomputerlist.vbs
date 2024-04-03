' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetComputerList.vbs 
' 
' 	Comments: Enumerate computer accounts for specified domain
'	If you want to save results, use console redirection:
'	cscript getcomputerlist.vbs >mycomputers.txt
'
'	or modify the script to create file using the FileSystemObject.
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
dim objDomain,objNetwork
Set objNetwork=CreateObject("WScript.Network")
strDomain=objNetwork.UserDomain

Set objDomain = GetObject("WinNT://" & strDomain)

count=0
objDomain.Filter = Array("computer")

  For Each x in objDomain
    If x.fullname<>"" Then
     wscript.echo x.name
     count=count+1
    End If
  Next
 
wscript.echo vbcrlf & "Counted " & count & " computer accounts in the " & domain & " domain."

Set objDomain=Nothing

wscript.quit


