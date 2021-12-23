' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: PhysicalMemoryQuery.vbs 
' 
' 	Comments: Display details of installed physical memory 
'	NOTES:  Script captures Computername, Bank and Capacity in bytes
'	You must have domain admin rights on the remote system.
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

Dim oWmi,oRef,objNetwork
Dim oLoc

'you can specify alternate credentials for remote systems.
'this is not really a best practice to hard code them in the
'script.  I'm just showing you how they are used.
'Set to "" if connecting to the local computer
strUser="domain\administator"
strPassword="Password"

strQuery="Select Tag,DeviceLocator,Capacity From Win32_PhysicalMemory"
Set objNetwork=CreateObject("wscript.network")

strSrv=InputBox("Enter a computer name to query:","Memory Query",objNetwork.ComputerName)

Set oLoc=CreateObject("WbemScripting.SWbemLocator")
oLoc.Security_.ImpersonationLevel=3
oLoc.Security_.AuthenticationLevel=WbemAuthenticationLevelPktPrivacy

WScript.Echo "Connecting to " & strSrv & " as " & strUser & " " & strPassword
set owmi=oLoc.ConnectServer(strSrv,"root\cimv2",strUser,strPassword)


Set oRef=oWmi.ExecQuery(strQuery) 
strMsg="Physical Memory configuration for " &_
 UCASE(strSrv) & VbCrLf

iTotMem=0
For Each detail In oRef 
iTotMem=iTotMem+FormatNumber(detail.Capacity/1024000,0)
strMsg=strMsg & detail.DeviceLocator & " = " &_
 FormatNumber(detail.Capacity/1024000,0) & "MB" & VbCrLf
Next
strMst=strMsg & "Total Installed = " & iTotMem & "MB"
wscript.echo strMsg
wscript.quit

'EOF