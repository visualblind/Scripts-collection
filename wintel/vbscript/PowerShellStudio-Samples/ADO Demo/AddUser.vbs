' **************************************************************************
' 
' 	Copyright (c) SAPIEN Technologies, Inc. All rights reserved
'   This file is part of the PrimalScript 2011 Code Samples.
' 
' 	File: AddUser.vbs
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
Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3

strTitle="Add User"

Set objConnection=CreateObject("ADODB.Connection")
Set objRecordSet=CreateObject("ADODB.Recordset")
objRecordSet.CursorLocation=adUseClient
objConnection.Open "DSN=XLTest;"

strOU=Trim(InputBox("What OU will the user belong to?",strTitle,"OU=Bedrock"))
strName=Trim(InputBox("What is the user's name?",strTitle,"Jane Slate"))
tmpArray=Split(strName," ")
strFirst=tmpArray(0)
strLast=tmpArray(1)
strSAM=Trim(InputBox("Confirm SAMAccount:",strTitle,LCase(Left(strFirst,1)&strLast)))
strEmail=Trim(InputBox("Confirm user's email:",strTitle,strSAM&"@scriptinganswers.com"))
strPhone=Trim(InputBox("Enter phone number:",strTitle,"1-800-555-9999"))

objRecordSet.Open "[Sheet 1$]",objConnection,adOpenStatic,adLockOptimistic

objRecordSet.AddNew
objRecordSet("DSRoot")=strOU
objRecordSet("email")=strEmail
objRecordset("samaccount")=strSAM
objRecordset("phone")=strPhone
objRecordSet("firstname")=strFirst
objRecordSet("lastname")=strLast
objRecordSet.Update

objRecordSet.Close

objConnection.Close

WScript.Quit



'EOF