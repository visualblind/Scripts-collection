'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  ShowServerInfo.vbs
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
dim objNetwork
dim objSrv
set objNetwork=CreateObject("WScript.Network")
strResults=""
strSrv=InputBox("Enter the computername you want to query.","Server Info",objNetwork.computername)

'strResults=strResults & "Getting information for " & srv
Set objSrv = GetObject("WinNT://" & strSrv & ",computer")
 if err.Number<>0 then
   strResults=strResults & "ERROR CONNECTING TO " & UCASE(strSrv)& "!"
else
  strHeader=UCASE(strSrv)& " Properties"
  strResults=strResults & strHeader & vbcrlf
  strResults=strResults & String(Len(strHeader),"_") & vbcrlf
  strResults=strResults & "Owner   " & vbtab & objSrv.Owner & vbcrlf
  strResults=strResults & "Organization" & vbtab & objSrv.Division & vbcrlf
  strResults=strResults & "OperatingSys  " & vbtab & objSrv.OperatingSystem & vbcrlf
  strResults=strResults & "OSVersion" & vbtab & objSrv.OperatingSystemVersion & vbcrlf
  strResults=strResults & "Processor" & vbtab & objSrv.Processor & vbcrlf
  strResults=strResults & "Proc. Count" & vbtab & objSrv.ProcessorCount & vbcrlf
end if

wscript.Echo strResults

