' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: WMISERVERINVENTORY.VBS 
' 
' 	Comments:
'
'	USAGE: cscript|wscript wmiserverinventory.vbs [serverlist.txt]
'	DESCRIPTION:  Take a text list of servers or computers and use WMI to build
'	an Excel spreadsheet with system information.  You must have Excel installed
'	on the computer where the script is running.  This script provides a centralized
'	source for server information.  The script will open the spreadsheet upon completion.
'	You can then save the file manually.
'
'	NOTES:  If you don't specify a serverlist you will be prompted.  The list should
'	just be a single column of servernames.  DO NOT USE \\ before the name.
'
'	The servers in the list should be running Windows 2000 SP3 or later.  See
'	Important Note below for more information.
'
'	Data captured:
'	ServerName,BootDevice,Caption,CSDVersion,FreePhysicalMemory,FreeVirtualMemory
'	InstallDate,LastBootUpTime,Status,SystemDevice,TotalVirtualMemorySize
'	TotalVisibleMemorySize,Version,WindowsDirectory,ServicePackMajorVersion
'	ServicePackMinorVersion, HotFix data 
'
'	Hotfix data includes hyperlinks to the appropriate Microsoft supporting
'	article.  Not every hotfix necessarily has a valid article, but most links should
'	work.  Each hotfix entry is a separate line so other information such as BootDevice
'	show up lower in the spreadsheet.  The script should be modified to jump back 
'	to the same row as the server name.
'
'	Includes formula for calculating system uptime.
'
'	Errors are redirected to a text file hardcoded as variable strErrorFile.
'
'	If you want to specify alternate credentials, you will need to 
'	rewrite the script to use the SWebmLocator object.
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

Dim objXL
Dim oFSO, oFile, oErrFile

On Error Resume Next

Const ReturnImmediately=&h10
Const ForwardOnly=&h20
Const ForReading=1
Const ForWriting=2

'file for error reporting
strErrorFile="ErrLog.txt"

Row=1
Column=1

If wscript.arguments.count=0 Then
	strSource=InputBox("Enter filename, and path if necessarily, of the " & _
	"file with your list of servers to inventory.","Server Inventory","servers.txt")
	If strSource="" Then
	  wscript.echo "Nothing entered or you cancelled."
	  wscript.quit
	End If
Else
	strSource=wscript.arguments(0)
End If

Set oFSO=CreateObject("Scripting.FileSystemObject")
If oFSO.FileExists(strSource) Then
	Set oFile=oFSO.OpenTextFile(strSource,ForReading)
Else
	wscript.echo "Can't find " & strSource
	wscript.quit
End If

Set oErrorFile=oFSO.CreateTextFile(strErrorFile)
oErrorFile.WriteLine wscript.ScriptName & " - Error Log " & NOW
oErrorFile.WriteLine String(70,"*")

Set objXL = WScript.CreateObject("Excel.Application")

'Place titles in workbook
objXL.Workbooks.Add
objXL.Cells(Row,Column).Value = "System"
Column=Column+1
objXL.Cells(Row,Column).Value = "OS"
Column=Column+1
objXL.Cells(Row,Column).Value =  "Hot Fixes" 
Column=Column+1
objXL.Cells(Row,Column).Value = "Windows Directory"
Column=Column+1
objXL.Cells(Row,Column).Value =  "Boot Device"
Column=Column+1
objXL.Cells(Row,Column).Value =  "System Device"
Column=Column+1
objXL.Cells(Row,Column).Value =  "Physical Memory"
Column=Column+1
objXL.Cells(Row,Column).Value =  "Virtual Memory" 
Column=Column+1
objXL.Cells(Row,Column).Value =  "Install Date" 
Column=Column+1
objXL.Cells(Row,Column).Value =  "Last Boot"
Column=Column+1
objXL.Cells(Row,Column).Value =  "Uptime" 
Column=Column+1
objXL.Cells(Row,Column).Value =  "Status" 


Do while oFile.AtEndOfStream<>True
	strSrv=UCASE(Trim(oFile.Readline))
	If Instr(" ",strSrv) Then	'don't process blank lines or lines with spaces
	Else
		wscript.echo "Analyzing " & strSrv
		GetInfo strSrv
	End If
Loop

oFile.Close
oErrorFile.Close

FormatXL
'add report run info as a footer
Row = Row+2
Column = 1
objXL.Cells(Row,Column).Select
objXL.Selection.Font.Italic = True
objXL.Cells(Row,Column).Value =  "Job run " & Now 

wscript.echo "Job complete.  See " & strErrorFile & " for any errors."

'Display finished spreadsheet
objXL.Range("A1").Select
objXL.Visible=True

Set objXL=Nothing
Set oFSO=Nothing
Set oFile=Nothing
Set oErrorFile=Nothing
wscript.quit

'************************************************************************************
' Get WMI Info
'************************************************************************************
Sub GetInfo(strSrv)
On Error Resume Next
dim oWMI,oRef
Row=Row+1
Column=1

strQuery="Select CSName,BootDevice,Caption,CSDVersion,FreePhysicalMemory,FreeVirtualMemory," & _
"InstallDate,LastBootUpTime,Status,SystemDevice,TotalVirtualMemorySize," & _
"TotalVisibleMemorySize,Version,WindowsDirectory,ServicePackMajorVersion," & _
"ServicePackMinorVersion FROM Win32_OperatingSystem"

Set oWMI=GetObject("Winmgmts://"&strSrv)
If Err.Number Then
  strErrMsg= "Error connecting to WINMGMTS on " & strSrv & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  strErrMsg = strErrMsg & String(70,"*") & vbCrlf
 oErrorFile.WriteLine strErrMsg 
'reset row count back one
 Row=Row-1
 Exit Sub
End If

Set oRef=oWMI.ExecQuery(strQuery,"WQL",ForwardOnly+ReturnImmediately)

If Err.Number Then
  strErrMsg= "Error executing query " & vbCrlf & strQuery & " on " & strSrv & vbCrlf
  strErrMsg= strErrMsg & "Error #" & err.number & " [0x" & CStr(Hex(Err.Number)) &"]" & vbCrlf
        If Err.Description <> "" Then
            strErrMsg = strErrMsg & "Error description: " & Err.Description & "." & vbCrlf
        End If
  Err.Clear
  strErrMsg = strErrMsg & String(70,"*") & vbCrlf
  oErrorFile.WriteLine strErrMsg
  Exit Sub
End If

for each item in oRef
 objXL.Cells(Row,Column).Value =  item.CSNAME
 Column=Column+1
 objXL.Cells(Row,Column).Value =  item.Caption & " ([" & item.Version & "] " & item.CSDVersion & ")"
 Column=Column+1
  'Get HotFix Info
   GetHotFix(strSrv)
 Column=Column+1
 objXL.Cells(Row,Column).Value =  item.WindowsDirectory
 Column=Column+1
 objXL.Cells(Row,Column).Value =  item.BootDevice
 Column=Column+1
 objXL.Cells(Row,Column).Value =  item.SystemDevice
: Column=Column+1
 objXL.Cells(Row,Column).Value =  FormatNumber(item.TotalVisibleMemorySize/1024,0) & "MB" & _
	" Total/" & FormatNumber(item.FreePhysicalMemory/1024,0) & "MB Free" & _
	" (" & FormatPercent(item.FreePhysicalMemory/item.TotalVisibleMemorySize,0) & ")"
 Column=Column+1
 objXL.Cells(Row,Column).Value =  FormatNumber(item.TotalVirtualMemorySize/1024,0) & "MB" & _
	" Total/" & FormatNumber(item.FreeVirtualMemory/1024,0) & "MB Free" & _
	" (" & FormatPercent(item.FreeVirtualMemory/item.TotalVirtualMemorySize,0) & ")"
 Column=Column+1
 objXL.Cells(Row,Column).Value =  ConvWMITime(item.InstallDate)
 Column=Column+1
 objXL.Cells(Row,Column).Value =  ConvWMITime(item.LastBootUpTime)
 Column=Column+1
	iDays=DateDiff("d",ConvWMITime(item.LastBootUpTime),Now)
	iHours=DateDiff("h",ConvWMITime(item.LastBootUpTime),Now)
	iMin=DateDiff("n",ConvWMITime(item.LastBootUpTime),Now)
	iSec=DateDiff("s",ConvWMITime(item.LastBootUpTime),Now)
	strUptime=iDays & " days " & (iHours Mod 24) & " hours " & (iMin Mod 60) & _
	" minutes " & (iSec Mod 60) & " seconds"
 objXL.Cells(Row,Column).Value =  strUptime
 Column=Column+1
 objXL.Cells(Row,Column).Value =  item.Status
 Column=Column+1

Next

Set oWMI=Nothing
Set oRef=Nothing

End Sub

'************************************************************************************
' Format Spreadsheet
'************************************************************************************
Sub FormatXL
On error Resume Next
'adjust formatting
    objXL.Rows("1:1").Select
    objXL.Selection.Font.Bold = True
    objXL.Selection.HorizontalAlignment = &HFFFFEFF4
    objXL.Cells.Select
    objXL.Cells.EntireColumn.AutoFit
    objXL.Selection.VerticalAlignment = &HFFFFEFC0
    objXL.Range("A1").Select
End Sub


'************************************************************************************
' Convert WMI Time Function
'************************************************************************************
On Error Resume Next
Function ConvWMITime(wmiTime)

yr = left(wmiTime,4)
mo = mid(wmiTime,5,2)
dy = mid(wmiTime,7,2)
tm = mid(wmiTime,9,6)

ConvWMITime = mo & "/" & dy & "/" & yr & " " & FormatDateTime(left(tm,2) & _
":" & Mid(tm,3,2) & ":" & Right(tm,2),3)

End Function

'************************************************************************************
' Get HotFix Data Subroutine
'************************************************************************************
Sub GetHotFix(strSrv)
On Error Resume Next
Dim oWMI2
strQuery="Select * from Win32_QuickFixEngineering"
Set oWMI2=GetObject("Winmgmts://"&strSrv)
Set oHotFixRef=oWMI2.ExecQuery(strQuery,"WQL",ForwardOnly+ReturnImmediately)

For Each hf In oHotFixRef
 objXL.Cells(Row,Column).Value=hf.HotFixID & " " & hf.Description
 If Instr(hf.Description,"See") Then		'if only Q Article in description, just use that as link text
	MakeLink hf.HotFixID,hf.Description
 Else
 	MakeLink hf.HotFixID,hf.HotFixID
 End If
 Row=Row+1
Next

Set oWMI2=Nothing
Set oHotFixRef=Nothing
'reset row 
Row=Row-1
End Sub

'************************************************************************************
' Create hyperlink to Q Article
'************************************************************************************
Sub MakeLink(HotFixID,strText)
On Error Resume Next

'Create hotlink to support information at Microsoft.  Not all links may necessarily
'work.  Uncomment next line for debugging
'wscript.echo "http://support.microsoft.com/default.aspx?scid=kb;EN-US;" & HotFixID
' Range("C14").Select
'    ActiveSheet.Hyperlinks.Add Anchor:=Selection, Address:= _
'        "http://www.sapien.com", TextToDisplay:= _
'        "Q314147 Windows XP Hotfix (SP1) [See Q314147 for more information]"
'
objXL.ActiveSheet.Hyperlinks.Add objXL.Cells(Row,Column),"http://support.microsoft.com/default.aspx?scid=kb;EN-US;" & _
 HotFixID,,,strText

End Sub


'EOF

