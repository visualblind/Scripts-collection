' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: GetUsers.vbs
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
Dim objConnection
Dim objRecordSet

Set objConnection=CreateObject("ADODB.Connection")
Set objRecordSet=CreateObject("ADODB.Recordset")
strQuery="Select * from [Sheet 1$]" ' where dsroot='ou=bedrock'"
' objConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;" &_
' "Data Source=c:\ado\users.xls;Extended Properties=Excel 8.0;"
objConnection.Open "DSN=XLTest;"
Set objRecordSet=objConnection.Execute(strQuery)

Do Until objRecordSet.EOF
	WScript.Echo objRecordSet.Fields("samaccount") & vbTab & objRecordSet.Fields("email")
	objRecordSet.MoveNext
Loop

objConnection.Close

WScript.Quit



'EOF