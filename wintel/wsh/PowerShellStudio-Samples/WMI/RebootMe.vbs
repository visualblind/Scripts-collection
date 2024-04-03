' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: RebootMe.vbs 
' 
' 	Comments:
'	This computer will REBOOT the computer or server that is
'	running this script.  It can be run interactively or as a scheduled
'	task.
' 
'   Disclaimer: This source code is intended only as a supplement to 
' 				SAPIEN Development Tools and/or on-line documentation.  
' 				See these other materials for detailed information 
' 				regarding SAPIEN code samples.
' 
' 	THIS CODE AND Information ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
' 	KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
' 	IMPLIED WARRANTIES OF MERCHANTABILITY And/OR FITNESS FOR A
' 	PARTICULAR PURPOSE.
' 
' **************************************************************************

Const ShutdownLocalPrivilege=18
Const Information=4
Call RebootIt()

'//////////////////////////////////////////////////////
'   SubRoutines
'//////////////////////////////////////////////////////

Sub RebootIt()
Dim objLocator
Dim objService
Dim objShell
Dim objNetwork

strServer="."
'you cannot use alternate credentials for the local system
strUsername=""
strPassword=""

Set objShell=CreateObject("WScript.Shell")
Set objNetwork=CreateObject("WScript.Network")

'Create locator
    Set objLocator = CreateObject("WbemScripting.SWbemLocator")
    If Err.Number Then
	WScript.Echo "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) & "] occurred in creating a locator object."
        
	If Err.Description <> "" Then
            WScript.Echo "Error description: " & Err.Description & "."
        End If
        Err.Clear
  	Exit Sub
    End If

'uncomment next line for debugging
'wscript.echo "Connecting to " & "("&strServer&",root\cimv2,"&strUserName&","&strPassword&")"
    Set objService = objLocator.ConnectServer (strServer,"root\cimv2",strUserName,strPassword)
    objService.Security_.impersonationlevel = 3
    objService.Security_.Privileges.Add ShutdownLocalPrivilege
   
    If Err.Number Then
	Wscript.Echo "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) &"] occurred in connecting to server " & strServer & "."
        If Err.Description <> "" Then
            Wscript.Echo "Error description: " & Err.Description & "." & VBCRLF & "You may also have incorrectly enterered the server name or your credentials are incorrect."
        End If
        Err.Clear
        Exit Sub
    End If

For Each item In objService.InstancesOf("Win32_OperatingSystem")
	strMsg= "Rebooting " & item.CSNAME & " " & Now & vbcrlf
	strMsg=strMsg & "Initiated by " & objNetwork.UserName
	'Log an informational message to the local system
	objShell.LogEvent Information,strMsg
	'uncomment the next line to perform an actual reboot. USE WITH CAUTION!!
	's=item.Reboot()	
Next

End Sub