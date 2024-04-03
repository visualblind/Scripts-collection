' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: ping.vbs
' 
' 	Comments:
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

Dim Ping

Set Ping = CreateObject("PrimalToys.Ping")

if Ping.Ping("microsoft.com",100) <> 0 Then
	WScript.Echo "Reply from " & Ping.ReplyAddress & ": Time=" & Ping.RTT & "ms"
Else
	WScript.Echo "No reply"
End If

if Ping.Ping("sapien.com",100) <> 0 Then
	WScript.Echo "Reply from " & Ping.ReplyAddress & ": Time=" & Ping.RTT & "ms"
Else
	WScript.Echo "No reply"
End If
