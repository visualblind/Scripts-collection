' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetOSInfo.vbs
' 
' 	Comments:
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
Dim oWMI
Dim oRef
Dim oCN
Dim oRS
Dim oArgs

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3
Const ReturnImmediately=&h10
Const ForwardOnly=&h20

'flag to show whether we are updating an existing record
blnUpdate=False

Set oArgs=WScript.Arguments
strSrv=oArgs(0)
Set oCN=CreateObject("ADODB.Connection")
Set oRS=CreateObject("ADODB.Recordset")

oCN.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=adosample.mdb;"
oRS.CursorLocation = adUseClient

'see if computer exists in database
strVerifyQuery="Select computername from computers where " &_
"computername='" & strSrv & "'"

oRS.Open strVerifyQuery,oCN,adOpenStatic,adLockOptimistic
if oRS.RecordCount=1 Then blnUpdate=True

oRS.Close
strQuery="Select * from computers where computername='" & strSrv & "'"
oRS.Open strQuery,oCN,adOpenStatic,adLockOptimistic

strWMIQuery="Select CSName,Caption,CSDVersion," &_
"FreePhysicalMemory,FreeVirtualMemory," & _
"InstallDate,TotalVirtualMemorySize," & _
"TotalVisibleMemorySize,WindowsDirectory," &_
"Organization,registereduser,serialnumber,description" &_
" FROM Win32_OperatingSystem"

'Get WMI information
Set oWMI=GetObject("Winmgmts://"&strSrv)
If Err.Number<>0 Then
	WScript.Echo "Failed to connect to WMI on " & strSrv
	WScript.Quit
End If
Set oRef=oWMI.ExecQuery(strWMIQuery,"WQL",ForwardOnly+ReturnImmediately)

If blnUpdate Then
	WScript.Echo "Updating " & strSrv
Else
	WScript.Echo "Adding new record for " & strSrv
	oRS.AddNew
End If

For Each item In oRef
	oRS.Fields("computername")= item.CSNAME
	oRS.Fields("os")= item.Caption
	oRS.Fields("servicepack")= item.CSDVersion
	oRS.Fields("windir")= item.WindowsDirectory
	oRS.Fields("freephysicalmemory")= item.FreePhysicalMemory
	oRS.Fields("freevirtualmemory")= item.FreeVirtualMemory
	oRS.Fields("totalvisiblememory")= item.TotalVisibleMemorySize
	oRS.Fields("totalvirtualmemory")= item.TotalVirtualMemorySize
	oRS.Fields("description")= item.description
	oRS.Fields("registereduser")= item.RegisteredUser
	oRS.Fields("organization")= item.Organization
	oRS.Fields("serialnumber")= item.serialnumber
	oRS.Fields("installdate")= ConvWMITime(item.installDate)
	oRS.Fields("lastupdated")=Now
Next

oRS.Update
If Err.Number=0 Then
	WScript.Echo "Database Update complete!"
Else
	WScript.Echo "There was a problem updating the database."
End if
oRS.Close
oCN.Close
WScript.Quit

'************************************************************************************
' Convert WMI Time Function
'************************************************************************************
On Error Resume Next
Function ConvWMITime(wmiTime)

yr = Left(wmiTime,4)
mo = Mid(wmiTime,5,2)
dy = Mid(wmiTime,7,2)
tm = mid(wmiTime,9,6)

ConvWMITime = mo & "/" & dy & "/" & yr & " " & FormatDateTime(left(tm,2) & _
":" & Mid(tm,3,2) & ":" & Right(tm,2),3)

End Function
