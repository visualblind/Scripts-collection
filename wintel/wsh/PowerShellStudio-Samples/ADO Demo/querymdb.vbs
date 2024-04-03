' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: QueryDB.vbs
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

Set oCN=CreateObject("ADODB.Connection")
strQuery="Select computername,os,servicepack from computers"
oCN.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=adosample.mdb;"

Set oRS=oCN.Execute(strQuery)

Do Until oRS.EOF
	WScript.Echo oRS.Fields("computername")
	WScript.Echo vbTab & oRS.Fields("os")
	WScript.Echo vbTab & oRS.Fields("servicepack")
oRS.MoveNext
Loop

oRS.Close
oCN.Close
