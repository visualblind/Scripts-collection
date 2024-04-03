'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ListGroupMembers.vbs
'
'	Comments:
'	USAGE: cscript dumpgroup.vbs [groupname]
'	for example:  cscript dumpgroup.vbs 
'	This script will list all members of the specified group. The members output will
'	also display their class, ie user or group.  Output is comma separated.
'
'	If you do not specify a groupname as a parameter, you will be prompted.
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
Dim objGrp, colArgs, objNetwork,objShell
Set objShell=CreateObject("wscript.shell")
set objNetwork=CreateObject("WScript.Network")
set colArgs=wscript.Arguments

'you can pass a group name as a parameter, otherwise you will be prompted.
if colArgs(0)="" then
 strGrpName=InputBox("Enter the name of the group to dump.  You quotes around names with spaces.",_
 "Group Info",CHR(34) & "Domain Admins" & Chr(34))
 else
strGrpName = colArgs(0)
end if

Set objGrp = GetObject("WinNT://" & objNetwork.UserDomain & "/" & strGrpName & ",group")
 if Err.Number <0 then
  wscript.echo "Failed to connect to " & objNetwork.UserDomain & " or find group " & UCASE(strGrpName)
  wscript.echo "Error #"&err.number
  wscript.echo "Error Description (if available): " & err.description
  set objGrp=Nothing
  wscript.quit
 end if
icount=0
set memberlist=objGrp.Members
for each member in memberlist
'display member name and class, such as user or computer
  wscript.echo member.Name & "," & member.Class 
  icount=icount+1
Next

strMsg="Counted " & icount & " members of " & objNetwork.UserDomain & "\" & strGrpName
objShell.Popup strMsg,10,"Group Info",0+64

wscript.quit

'EOF