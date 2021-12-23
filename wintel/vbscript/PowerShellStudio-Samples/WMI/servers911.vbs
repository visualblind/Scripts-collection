' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: SERVERS911.VBS 
' 
' 	Comments:
'	Perform emergency shutdown of servers from serverlist using WMI.  
'	Includes event logging to the server shutting down so you have a record of the event.
'	The script will broadcast to the domain using a NET SEND command announcing the shutdown.
'	You will want to modify the message.
'
'	NOTES:  The target servers must be running Windows 2000/2003 or if NT, have the WMI 
'	core installed.  The script as written cannot shut down the system that is running
'	this script.
'
'	The server list should look like:
'	server01
'	dc1
'	file23
'
'	You are better off using cscript to run this.
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

On Error Resume Next

'Set variables and constants
Dim oNet,oFso,oFile,oWsh
Const SourceFile="servers.txt"			'"servers.txt" List of servers
Const strUserName="myDomain\ShutdownMan"  'Account with shutdown privileges
Const strPassword="$ecr3tP@ssworD"		'Account password
Const WARNING=2
Const ShutdownLocalPrivilege=18
Const ShutdownRemotePrivilege=23

Set oWsh=CreateObject("wscript.shell")
Set oNet=CreateObject("wscript.network")
strDomain=oNet.UserDomain

Set oFso=CreateObject("Scripting.FileSystemObject")
'Verify text file exists
If oFso.FileExists(SourceFile) Then 
	'wscript.echo "found " & SourceFile
	'Send broadcast message to domain
	'wscript.echo "sending broadcast message to " & strDomain & " " & oNet.ComputerName
	m=oWsh.Run("net send " & oNet.ComputerName & " SHUTDOWN TEST.  " &_
	"NOTHING WILL REALLY HAPPEN.",,True)
	'Open text file and read entries
	Set oFile=oFso.OpenTextFile(SourceFile)
	Do While oFile.AtEndOfStream<>True
	strServer=oFile.Readline
	'Call Shutdown server subroutine
	ShutItDown(strServer)	
    Loop
Else
	wscript.echo "Can't find " & SourceFile
End If

'end of main script

'//////////////////////////////////////////////////////
'   SubRoutines
'//////////////////////////////////////////////////////

Sub ShutItDown(Server)
Dim objLocator

'uncomment next line for debugging
'wscript.echo "Shutting down " & strServer & " as " & strUserName

'Connect to remote system
'Create locator
    Set objLocator = CreateObject("WbemScripting.SWbemLocator")
    If Err.Number Then
	Wscript.Echo "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) & "] occurred in creating a locator object."
        
	If Err.Description <> "" Then
            Wscript.Echo "Error description: " & Err.Description & "."
        End If
        Err.Clear
  	Exit Sub
    End If

'uncomment next line for debugging
'wscript.echo "Connecting to " & "("&strServer&",root\cimv2,"&strUserName&","&strPassword&")"
    Set objService = objLocator.ConnectServer (strServer,"root\cimv2",strUserName,strPassword)
    objService.Security_.impersonationlevel = 3
    objService.Security_.Privileges.Add ShutdownLocalPrivilege
    objService.Security_.Privileges.Add ShutdownRemotePrivilege
   
    If Err.Number Then
	Wscript.Echo "Error " & err.number & " [0x" & CStr(Hex(Err.Number)) &"] occurred in connecting to server " & strServer & "."
        If Err.Description <> "" Then
            Wscript.Echo "Error description: " & Err.Description & "." & VBCRLF & "You may also have incorrectly enterered the server name or your credentials are incorrect."
        End If
        Err.Clear
        Exit Sub
    End If

For Each item In objService.InstancesOf("Win32_OperatingSystem")
	'Write to remote event log.  You can customize this message.
	oWsh.LogEvent WARNING,"Emergency Shutdown initiated.","\\" & strServer
	
	'Initiate Remote Shutdown
	wscript.echo "Shutting down " & item.CSNAME
	'uncomment  the next line to do an actual shutdown. USE WITH CAUTION!!!
	's=item.Shutdown()	
Next

End Sub

'EOF