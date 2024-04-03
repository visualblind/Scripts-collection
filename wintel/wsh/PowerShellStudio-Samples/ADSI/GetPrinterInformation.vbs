'**************************************************************************
'
'	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
'
'	File:  GetPrinterInformation.vbs
'
'	Comments: Enumerate printers on specified server and show print configuration
'	USAGE: cscript GETPRINTINFO.VBS servername
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
dim objComputer,oArgs

If LCase(ChkEngine)="wscript.exe" Then
 wscript.echo "You should really run this script using CSCRIPT.EXE" & VbCrLf &_
  "The output is formatted for screen display.  If you want, you can redirect the output to a text file: " &_
   VbCrLf & VbCrLf & "  cscript printinfo.vbs servername >servername_printers.txt"
 wscript.quit
End If

Set oArgs=wscript.Arguments

If oArgs.Count<1 then
 msg="  Syntax Error - Missing Parameter  "
 wscript.echo VBCRLF & String(Len(msg),CHR(22))& VbCrLf & msg & VbCrLf &_
  String(Len(msg),CHR(22))& VbCrLf
 Usage
End If

If InStr(oArgs(0),"?")<>0 Then
 msg="  Help - " & wscript.scriptname & "  "
 wscript.echo VbCrLf & String(Len(msg),CHR(22))& VbCrLf & msg & VbCrLf &_
  String(Len(msg),CHR(22))& VbCrLf & VbCrLf & "Enumerate printers on specified server and show print configuration." & VbCrLf
 Usage
End If

Set objComputer = GetObject("WinNT://"&oArgs(0)&",computer")
If err.number<>0 Then
 wscript.echo "Could not connect to " & oArgs(0) &_
  ".  Verify server name and/or that you have correct permissions."
 wscript.quit
End If

msg=" Printer Information: " & oArgs(0) & "  "
wscript.echo VBCRLF & String(Len(msg),CHR(22))& VbCrLf & msg & VbCrLf &_
 String(Len(msg),CHR(22))& VbCrLf

wscript.echo "Connecting to " & oArgs(0)& "..." & VbCrLf

objComputer.Filter = Array("PrintQueue")
pinfo=""
For Each p In objComputer
  Set pq = GetObject(p.ADsPath)
  wscript.echo "Gathering printer information for " & UCASE(pq.name)
  pinfo=String(50,CHR(22)) & VbCrLf
  pinfo=pinfo & "Shared as:  " & vbTab & pq.name & VbCrLf
  pinfo=pinfo & "Printer Name: " & vbTab & pq.PrinterName & VbCrLf
  pinfo=pinfo & "Model: " & vbTab & vbTab & pq.Model & VbCrLf
  pinfo=pinfo & "Comments: " & vbTab & pq.Description & VbCrLf
  pinfo=pinfo & "Location: " & vbTab & pq.Location & VbCrLf
  pinfo=pinfo & "Processor: " & vbTab & pq.PrintProcessor & VbCrLf
  pinfo=pinfo & "Devices: " & vbTab & pq.PrintDevices & VbCrLf
  pinfo=pinfo & "DataType: " & vbTab & pq.Datatype & VbCrLf
  pinfo=pinfo & "Priority: " & vbTab & pq.DefaultJobPriority & VbCrLf
  pinfo=pinfo & "Current Jobs: " & vbTab & pq.JobCount & VbCrLf
	if pq.JobCount>0 then
	' pinfo=pinfo &  VBTAB & "Job Detail" & VBCRLF
	 Set pqo = GetObject("WinNT://"&oArgs(0)&"/"&pq.name)
	   For each pj in pqo.PrintJobs
		pinfo=pinfo & vbTab & pj.Description & VbCrLf
    		pinfo=pinfo & vbTab & "Requested by " & pj.User & " at " & pj.TimeSubmitted & VbCrLf
	      pinfo=pinfo & vbTab & "Size: " & pj.size & " bytes (" & pj.TotalPages & " pages)." & VbCrLf & VbCrLf
         Next
    end If

  pinfo=pinfo & "Banner Page: " & vbTab & pq.BannerPage & VbCrLf
  pinfo=pinfo & "Path: " & vbTab & vbTab & pq.PrinterPath & VbCrLf
  pinfo=pinfo & "NetAddress: " & vbTab & pq.NetAddresses & VbCrLf
  pinfo=pinfo & "Available: " & vbTab & pq.Starttime & "  to " & pq.UntilTime & VbCrLf
    Select Case pq.Status
	Case "0" CurStatus="Online"
	Case "1" CurStatus="Paused"
	Case "2" CurStatus="Pending Deletion"
	Case "3" CurStatus="Error"
	Case "4" CurStatus="Paper Jam"
	Case "5" CurStatus="Paper Out"
	Case "6" CurStatus="Manual Feed"
	Case "7" CurStatus="Paper Problem"
	Case "8" CurStatus="Offline"
	Case "256" CurStatus="IO Active"
	Case "512" CurStatus="Busy"
	Case "1024" CurStatus="Printing"
	Case "2048" CurStatus="Output Bin Full"
	Case "4096" CurStatus="Not Available"
	Case "8192" CurStatus="Waiting"
	Case "6384" CurStatus="Processing"
	Case "32768" CurStatus="Initializing"
	Case "65536" CurStatus="Warming Up"
	Case "131072" CurStatus="Toner Low"
	Case "262144" CurStatus="No Toner"
	Case "524288" CurStatus="Page Punt"
	Case "1048576" CurStatus="User Intervention"
	Case "2097152" CurStatus="Out of Memory"
	Case "4194304" CurStatus="Door Open"
	Case "8388608" CurStatus="Server Unknown"
	Case "16777216" CurStatus="Power Save"
	Case Else CurStatus="Can't evaluate current status"
  End Select

  pinfo=pinfo & "Currently: " & vbTab & CurStatus & VbCrLf
  wscript.echo pinfo
Next

  wscript.echo "If nothing is displayed or some information is missing," & VbCrLf &_
   "it is either not configured or you don't have permission to view it."

wscript.quit

'************************
'*  Usage Subroutine    *
'************************
Sub Usage()
msg="Usage: cscript " & wscript.ScriptName & " servername" & VbCrLf  &_
 "DO NOT use \\ before the server name.    " & VbCrLf & "  Example: " &_
  VbCrLf & "  cscript " & wscript.ScriptName & " PrintSrv01" & VbCrLf & VbCrLf &_
   "cscript " & wscript.ScriptName & " /?|-? will display this message."

wscript.echo msg

wscript.quit

End Sub

'************************
'*  ChkEngine Function  *
'************************
Function ChkEngine()

On Error Resume Next

strEngine=Wscript.FullName

if Err.Number <>0 then
 wscript.echo "Error!"
  wscript.echo "Error (" & Err.Number & ") Description: " & Err.Description
  wscript.quit
end if

PosX=InStrRev(strEngine,"\",-1,vbTextCompare)
ChkEngine=Mid(strEngine,PosX+1)

End Function

