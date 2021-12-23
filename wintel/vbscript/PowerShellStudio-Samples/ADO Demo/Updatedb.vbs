' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: UpdateDB.vbs
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
Dim oCN
Dim oRS

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3

Set oCN=CreateObject("ADODB.Connection")
Set oRS=CreateObject("ADODB.Recordset")
strQuery="Select computername from Computers"

oCN.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=adosample.mdb;"
oRS.CursorLocation = adUseClient
oRS.Open strQuery,oCN,adOpenStatic,adLockOptimistic

Do Until oRS.EOF
' WScript.echo "Updating " & oRS.Fields("computername")
strServicePack=GetServicePack(oRS.Fields("computername"))

If strServicePack<>"notfound" Then
	strUpdate="Update Computers set Servicepack='" & strServicePack &_
	"',lastupdated='" & Now & "' where computername='" & oRS.Fields("computername") & "'"
	oCN.Execute strUpdate
End If

oRS.MoveNext
loop

oRS.Close
oCN.Close
WScript.Quit

Function GetServicePack(strComputer)
On Error Resume Next
WScript.Echo "Getting Service pack info for " & strComputer
Dim objWMI
Dim objRef

Const ReturnImmediately=&h10
Const ForwardOnly=&h20
 strQuery="Select CSDVersion from win32_operatingsystem"

Set objWMI=GetObject("winmgmts://" & strComputer)
If Err.Number<>0 Then 
	GetServicePack="notfound"
	Exit Function
End If

Set objRef=objWMI.ExecQuery(strQuery,"WQL",ForwardOnly+ReturnImmediately)

For Each item In objRef
	GetServicePack=item.CSDVersion
Next

End Function


