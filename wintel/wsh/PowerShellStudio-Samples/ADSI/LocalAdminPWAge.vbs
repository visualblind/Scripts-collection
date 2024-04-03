'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  LocalAdminPWAge.vbs
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

On Error Resume Next

dim oAdmin
dim wshNetwork
Dim sUser

sUser="Administrator"

Set wshNetwork=CreateObject("wscript.network")

If wscript.Arguments.Item(0)="" Then 
	strSrv=wshNetwork.ComputerName
Else
	strSrv=Trim(UCase(WScript.Arguments.Item(0)))
End If
set oAdmin=GetObject("WinNT://" & strSrv & "/" & sUser &",user")
If oAdmin.Name="" Then
	WScript.Echo strSrv & " FAILED TO CONNECT"
Else
	wScript.Echo oAdmin.ADSPath & " " &	FormatNumber(oAdmin.PasswordAge/86400) 
End If
