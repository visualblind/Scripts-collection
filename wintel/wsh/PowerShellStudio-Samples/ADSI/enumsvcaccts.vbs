' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: EnumSvcAccts.vbs 
' 
' 	Comments:
'	Enumerate service accounts on specified machine.  Output is
'	in a comma delimited format. Existing files will be overwritten.
'	revised 9/10/2002 to include server name in output and to read in list of servers.  
'
'	csv format:
'	Server,Service Display Name, Real Service Name, Service Account
'	You must have appropriate admin rights on the target computer.  Target can be running
'	NT, Win2K/2003 or XP.
'
'	It is recommended to use cscript to execute this script.
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
Dim oSvc,oPC, objNetwork
dim objFSO,objFile,objFile2

Const ForReading=1
Const ForWriting=2
set objNetwork=CreateObject("Wscript.Network")

ServerList="jdhservers.txt"		'name of file with server names to check.
OutputFile="svcaccounts.csv"	'file to hold results

set objFSO=CreateObject("Scripting.FileSystemObject")
set objFile=objFSO.OpenTextfile(serverlist,forReading)
set objFile2=objFSO.CreateTextFile(OutPutfile)

do while objFile.AtEndofStream<>True
 sTarget=objFile.Readline
 wscript.echo "Enumerating Service Accounts on " & sTarget

Set oPC=GetObject("WinNT://"&sTarget)
'verify connectivity
tmp=oPC.Owner
If err.number<>0 Then
   wscript.echo "Error connecting to " & sTarget
   wscript.echo "Error #"&Err.Number & ": " & Err.Description
   wscript.quit
End If

objFile2.WriteLine "Server,Display Name,Service Name,Service Account Name"
oPC.Filter=Array("service")
 For Each svc In oPC
  objFile2.WriteLine sTarget &"," & svc.DisplayName & "," & svc.Name & "," & svc.ServiceAccountName
 Next

set oPC=Nothing
set objNetwork=Nothing

loop

objFile.close
objFile2.close

wscript.echo "See " & OutPutfile & " for results."

'EOF