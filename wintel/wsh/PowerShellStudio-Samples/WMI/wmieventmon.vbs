' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMIEVENTMON.VBS 
' 
' 	Comments:
'	USAGE: cscript|wscript wmieventmon.vbs [server]
'	DESCRIPTION: DEMO SCRIPT TO SHOW BLOCKING AND WAITING FOR AN EVENT TO HAPPEN
'	IN THIS CASE A NEW ENTRY IN THE NT EVENT LOG. 
'	NOTES: Script works best using CSCRIPT.  This script just waits for the next event then
'	displays some information and ends.  Not intended as a production script but rather to
'	illustrate the use of blocking.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

Dim oWMI,oEventSrc,NTEvent
On Error Resume Next
strQuery="Select * from __InstanceCreationEvent WHERE TargetInstance ISA 'Win32_NTLogEvent'"

If WScript.argments.count=0 Then
	Set oWMI=GetObject("winmgmts:{(security)}") 'need security privilege
Else
	strSrv=wscript.argments(0)
	Set oWMI=GetObject("winmgmts:{(security)}!\\"&strSrv&":")
	If Err.number<>0 Then
		strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        		If Err.Description <> "" Then
            		strErrMsg = strErrMsg & "Error description: " & Err.Description & "."
		      End If
  		Err.Clear
		wscript.echo strErrMsg
		wscript.quit
	End If
End If
Set oEventSrc=oWMI.ExecNotificationQuery(strQuery)

'start blocking
Set NTEvent=oEventSrc.NextEvent()
logtime=NTEvent.TargetInstance.TimeGenerated
logyr = left(logtime,4)
logmo = mid(logtime,5,2)
logdy = mid(logtime,7,2)
logtm = mid(logtime,9,6)

strMsg=NTEvent.TargetInstance.ComputerName & vbcrlf

strMsg=strMsg & "Event ID: " & NTEvent.TargetInstance.EventCode & "   Source: " & _
 NTEvent.TargetInstance.SourceName & vbTab & logmo&"/"&logdy&"/"&logyr & _
  " [" & FormatDateTime(left(logtm,2) & ":"&Mid(logtm,3,2) & _
  ":"&Right(logtm,2),3) & "]" & VbCrLf & NTEvent.TargetInstance.Message

wscript.echo strMsg

'EOF
