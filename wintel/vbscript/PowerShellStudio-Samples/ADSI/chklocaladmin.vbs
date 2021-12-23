' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: CHKLOCALADMIN.VBS 
' 
' 	Comments:
'	USAGE: cscript|wscript chklocaladmin.vbs
'	DESCRIPTION:  Add Domain Admins (or any specified group) to Local Administrators Group
'	NOTES:  You can use this as a computer startup script to enforce particular membership
'	of the local Administrators group.  If you use as a startup script, you will need to hard
'	code the strDomain value.  An alternative could be to configure loopback processing
'	so that user settings apply to the computer.  This script has NOT been tested
'	with loopback processing.
'
'	You can run this as a logon or standalone script, but the user running it must
'	have admin rights on the computer.
'
'	Uncomment additional lines of code to help with debugging or troubleshooting.
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
dim objSrv,wshNetwork
set wshNetwork=CreateObject("Wscript.Network")

strSrv=wshNetwork.ComputerName
'hardcode domain name if using this as a computer start up script
'this setting assumes you are running the script interactively as
'a user.
strDomain=wshNetwork.UserDomain

'Group to search for. You do not need to specify the domain name.
strGrp="Domain Admins"

'wscript.Echo "Checking local Administrator group on " & strSrv & " for " & strDomain & "\" & strGrp
Set objSrv = GetObject("WinNT://" & strSrv & "/Administrators,group")
'set memberlist=objSrv.Members
'	for each member in memberlist
'		wscript.echo member.Name & " (" & member.ADSpath & ")"
'	next
if objSrv.IsMember("WinNT://" & strDomain & "/" & strGrp) then
'	wscript.Echo "found " & strDomain & "\" & strGrp
else
'	wscript.Echo "not found " &  strDomain & "\" & strGrp
'	wscript.Echo "Adding WinNT://" & strDomain & "/" & strGrp
	objSrv.Add("WinNT://" & strDomain & "/" & strGrp)
end If

Set wshNetwork=Nothing
Set objSrv=Nothing
'EOF