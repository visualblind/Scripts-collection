'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  EnumerateServices.vbs
'
'	Comments: Enumerate all services on specified server
'	You should use CSCRIPT to run this or you will be pressing Enter
'	for a long time.
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

Dim objSvc,objPC,objNetwork
set objNetwork=CreateObject("Wscript.Network")

  sTarget=InputBox("What computer do you want to query for service information?",_
  "Service Information",objNetwork.ComputerName)
	If sTarget="" Then
	  wscript.echo "Nothing entered or you cancelled."
	  wscript.quit
	End If

wscript.echo "Enumerating Services on " & sTarget & "(" & NOW& ")" & VBCRLF

Set objPC=GetObject("WinNT://"&sTarget)
'verify connectivity
tmp=objPC.Owner
If err.number<>0 Then
   wscript.echo "Error connecting to " & sTarget
   wscript.echo "Error #"&Err.Number & ": " & Err.Description
   wscript.quit
End If

objPC.Filter=Array("service")

 For Each objService In objPC
s=""
  s=s & "Display Name:" & vbtab & vbtab & objService.DisplayName  & VBCRLF
  s=s & "Service name:" & vbtab & vbtab & objService.Name & VBCRLF
  s=s & "Service Account:" & vbtab & objService.ServiceAccountName & VBCRLF
 
Select Case objService.Status
  Case "1"	statusDetail="Stopped"
  Case "4"	statusDetail="Running"
  Case Else	statusDetail="Unknown"
End Select

s=s & "Status:" & vbTAB & vbTAB & vbTAB & objService.status & " ("&statusDetail &")" & VBCRLF
s=s & "HostComputer" & vbTAB & vbTAB & objService.HostComputer & VBCRLF
s=s & "LoadOrderGroup" & vbTAB & vbTAB & objService.LoadOrderGroup & VBCRLF
s=s & "ServiceAccountName:" & vbTAB & objService.ServiceAccountName & VBCRLF

depend=objService.GetEx("Dependencies")
 if err.Number<>0 then
   errchk=1
   err.clear
 else
   s=s & "Dependencies:" & VBCRLF
  for each z in depend
   s=s & vbTAB & vbTAB & vbTAB & z & VBCRLF
  next
 end if

Select Case objService.StartType
  Case "0"	StartDetail="Boot"
  Case "1"	StartDetail="System"
  Case "2"	StartDetail="Automatic"
  Case "3"	StartDetail="Manual"
  Case "4"	StartDetail="Disabled"
  Case Else	StartDetail="Unknown"
End Select
s=s & "StartType: " & vbTAB & vbTAB & objService.StartType & " (" & StartDetail &")" & VBCRLF

Select Case objService.ServiceType 
  Case "1"	ServiceDetail="Kernel-Mode Driver"
  Case "2"	ServiceDetail="File System Driver"
  Case "4"	ServiceDetail="Adapter Arguments"
  Case "8"	ServiceDetail="File System Driver Service"
  Case "16"	ServiceDetail="Own Process"
  Case "32"	ServiceDetail="Shared Process"
  Case "272"	ServiceDetail="Own Process - Interactive"
  Case "288"	ServiceDetail="Shared Process - Interactive"
  Case Else	ServiceDetail="Unknown"
End Select
s=s & "ServiceType:" & vbTAB & vbTAB & objService.ServiceType & " (" & ServiceDetail &")" & VBCRLF
 
s=s & "DisplayName:"& vbTAB & vbTAB & objService.DisplayName & VBCRLF
s=s & "Path:" & vbTAB & vbTAB & vbTAB &objService.Path & VBCRLF

Select Case objService.ErrorControl
  Case "0"	ErrorDetail="Ignore"
  Case "1"	ErrorDetail="Normal"
  Case "2"	ErrorDetail="Severe"
  Case "3"	ErrorDetail="Critical"
  Case Else	ErrorDetail="Unknown"
End Select
s=s & "ErrorControl:" & vbTAB & vbTAB & objService.ErrorControl & " (" & ErrorDetail &")" & VBCRLF & VBCRLF

 if errchk=1 then
   s=s & "Dependencies were skipped as they either weren't applicable or found." & VBCRLF
 end if

wscript.echo s
next


'EOF
